#!/usr/bin/env sh
# Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# ==================== RAM ====================
echo "🖥️ RAM: "

awk '
/^MemTotal:/ {
	mem_total=$2
}
/^MemFree:/ {
	mem_free=$2
}
/^Buffers:/ {
	mem_free+=$2
}
/^Cached:/ {
	mem_free+=$2
}
/^SwapTotal:/ {
	swap_total=$2
}
/^SwapFree:/ {
	swap_free=$2
}
END {
  free=mem_free/1024/1024
  used=(mem_total-mem_free)/1024/1024
  total=mem_total/1024/1024
	pct=0
	if (total > 0) {
		pct=used/total*100
	}
  printf("%.1fG/%.1fG (%.f%%)\n", used, total, pct)
}
' /proc/meminfo

# ==================== CPU ====================

echo " | CPU: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"% "

ICONl=" " # icon for normal temperatures
ICONn=" " # icon for normal temperatures
ICONc=" " # icon for critical temperatures

crit=70 # critical temperature
norm=40 # normal temperatures

read -r temp </sys/class/thermal/thermal_zone1/temp
temp="${temp%???}"

if [ "$temp" -lt "$norm" ] ; then
  printf "$ICONl%s°C" "$temp"
elif [ "$temp" -lt "$crit" ] ; then
  printf "$ICONn%s°C" "$temp"
else
  printf "$ICONc%s°C" "$temp"
fi
