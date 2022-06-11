
LYNS_STATICBATTERY_SHOW="${LYNS_STATICBATTERY_SHOW=true}"
LYNS_STATICBATTERY_PREFIX="${LYNS_STATICBATTERY_PREFIX=""}"
LYNS_STATICBATTERY_SUFFIX="${LYNS_STATICBATTERY_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICBATTERY_SYMBOL_CHARGING="${LYNS_STATICBATTERY_SYMBOL_CHARGING="⇡"}"
LYNS_STATICBATTERY_SYMBOL_DISCHARGING="${LYNS_STATICBATTERY_SYMBOL_DISCHARGING="⇣"}"
LYNS_STATICBATTERY_SYMBOL_FULL="${LYNS_STATICBATTERY_SYMBOL_FULL="•"}"
LYNS_STATICBATTERY_THRESHOLD="${LYNS_STATICBATTERY_THRESHOLD=10}"

_lyns_battery() {
  [[ $LYNS_STATICBATTERY_SHOW == false ]] && return

  local battery_data battery_percent battery_status battery_color

  if asyncs::exists pmset; then
    battery_data=$(pmset -g batt | grep "InternalBattery")

    
    [[ -z "$battery_data" ]] && return
    
    
    battery_percent="$( echo $battery_data | \grep -oE '[0-9]{1,3}%' )"
    battery_status="$( echo $battery_data | awk -F '; *' '{ print $2 }' )"
  elif asyncs::exists acpi; then
    battery_data=$(acpi -b 2>/dev/null | head -1)

    
    [[ -z $battery_data ]] && return

    battery_status_and_percent="$(echo $battery_data |  sed 's/Battery [0-9]*: \(.*\), \([0-9]*\)%.*/\1:\2/')"
    battery_status_and_percent_array=("${(@s/:/)battery_status_and_percent}")
    battery_status=$battery_status_and_percent_array[1]:l
    battery_percent=$battery_status_and_percent_array[2]

	
    [[ $battery_percent == "0" ]] && return

  elif asyncs::exists upower; then
    local battery=$(command upower -e | grep battery | head -1)

    
    [[ -z $battery ]] && return

    battery_data=$(upower -i $battery)
    battery_percent="$( echo "$battery_data" | grep percentage | awk '{print $2}' )"
    battery_status="$( echo "$battery_data" | grep state | awk '{print $2}' )"
  else
    return
  fi

  
  battery_percent="$(echo $battery_percent | tr -d '%[,;]')"

  
  if [[ $battery_percent == 100 || $battery_status =~ "(charged|full)" ]]; then
    battery_color="green"
  elif [[ $battery_percent -lt $LYNS_STATICBATTERY_THRESHOLD ]]; then
    battery_color="red"
  else
    battery_color="yellow"
  fi

  
  if [[ $battery_status == "charging" ]];then
    battery_symbol="${LYNS_STATICBATTERY_SYMBOL_CHARGING}"
  elif [[ $battery_status =~ "^[dD]ischarg.*" ]]; then
    battery_symbol="${LYNS_STATICBATTERY_SYMBOL_DISCHARGING}"
  else
    battery_symbol="${LYNS_STATICBATTERY_SYMBOL_FULL}"
  fi

  
  if [[ $LYNS_STATICBATTERY_SHOW == 'always' ||
        $battery_percent -lt $LYNS_STATICBATTERY_THRESHOLD ||
        $LYNS_STATICBATTERY_SHOW == 'charged' && $battery_status =~ "(charged|full)" ]]; then
    asyncs::section \
      "$battery_color" \
      "$LYNS_STATICBATTERY_PREFIX" \
      "$battery_symbol$battery_percent%%" \
      "$LYNS_STATICBATTERY_SUFFIX"
  fi
}
