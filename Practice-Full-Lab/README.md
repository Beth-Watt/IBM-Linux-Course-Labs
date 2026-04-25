# Script Practice Lab – Weather Forecasting Bash Scripts

## Overview
This lab focuses on writing and iteratively building Bash shell scripts to extract live weather data, log observations, compute forecast accuracy, and calculate weekly statistics. All scripts were developed in the Theia IDE using GNU nano and executed in a Linux terminal environment.

---

## Lab Steps & Screenshots

### 1. Initial Script – Extract Current Temperature (`1_ScriptPractice.png`)
Opened `rx_poc.sh` in nano and wrote the first version of the script:
- Set `city=Casablanca`
- Used `curl -s wttr.in/$city?T` piped through `grep` and regex to extract the current observed temperature into `$obs_temp`
- Printed: `"The current Temperature of $city: $obs_temp"`

```bash
#!/bin/bash
city=Casablanca
obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 ' .' | grep -Eo -e '-?[[:digit:]].*')
echo "The current Temperature of $city: $obs_temp"
```

### 2. Add Forecast Temperature (`2_ScriptPractice.png`)
Extended `rx_poc.sh` to also extract the forecasted temperature for noon tomorrow:
- Used `curl` piped through `head -23 | tail -1 | grep | cut -d 'C' -f2` to parse the forecast value into `$fc_temp`
- Printed: `"The forecasted temperature for noon tomorrow for $city : $fc_temp C"`

```bash
fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep ' .' | cut -d 'C' -f2 | gr...)
echo "The forecasted temperature for noon tomorrow for $city : $fc_temp C"
```

### 3. Add Timezone & Date Variables (`3_ScriptrPractice.png`)
Added timezone assignment and command substitution for date components:

```bash
TZ='Morocco/Casablanca'
day=$(TZ='Morocco/Casablanca' date -u +%d)
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)
```

### 4. Full Script – Log the Weather Record (`4_ScriptPractice.png`)
Assembled the complete `rx_poc.sh` with all variables and a log append step:

```bash
record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")
echo "$record">>rx_poc.log
```

### 5. Script Schedule – Log the Weather (`5_ScriptSchedule.png`)
Confirmed the final logging section of the script meant to run on a scheduled basis:

```bash
# Log the weather
record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")
echo "$record">>rx_poc.log
```

### 6. Historical Weather Setup (`6_ScriptHistoricalWeather.png`)
Created supporting files for historical accuracy tracking:
- Created `historical_fc_accuracy.tsv` with columns: `year`, `month`, `day`, `obs_temp`, `fc_temp`, `accuracy`, `accuracy_range`
- Created `fc_accuracy.sh` for computing accuracy
- Extracted `yesterday_fc` using `tail -2 rx_poc.log | head -1 | cut -d " " -f5`
- Verified `rx_poc.log` entries showing **2026-04-25**, obs temp **64°F**, forecast **69°F**

### 7. Forecast Accuracy Script (`7_ScriptHead___Tail.png`)
Wrote the full `fc_accuracy.sh` script with conditional accuracy ranges:

| Range | Condition |
|-------|-----------|
| `excellent` | -1 ≤ accuracy ≤ 1 |
| `good` | -2 ≤ accuracy ≤ 2 |
| `fair` | -3 ≤ accuracy ≤ 3 |
| `poor` | all others |

```bash
#!/bin/bash
yesterday_fc=$(tail -2 rx_poc.log | head -1 | cut -d " " -f5)
today_temp=$(tail -1 rx_poc.log | cut -d " " -f4)
accuracy=$(($yesterday_fc-$today_temp))

if [ -1 -le $accuracy ] && [ $accuracy -le 1 ]
then
    accuracy_range=excellent
elif [ -2 -le $accuracy ] && [ $accuracy -le 2 ]
then
    accuracy_range=good
elif [ -3 -le $accuracy ] && [ $accuracy -le 3 ]
then
    accuracy_range=fair
else
    accuracy_range=poor
fi

echo "Forecast accuracy is $accuracy"
```

### 8. Weekly Stats Script – Part 1 (`8_ScriptWeekly.png`)
Extracted last 7 accuracy values, loaded into array, and converted to absolute values:

```bash
#!/bin/bash
echo $(tail -7 synthetic_historical_fc_accuracy.tsv | cut -f6) > scratch.txt
week_fc=($(echo $(cat scratch.txt)))

for i in {0..6}; do
    echo ${week_fc[$i]}
done

for i in {0..6}; do
  if [[ ${week_fc[$i]} < 0 ]]
  then
    week_fc[$i]=$(( (-1)*week_fc[$i] ))
  fi
  echo ${week_fc[$i]}
done

minimum=${week_fc[1]}
```

### 9. Weekly Stats Script – Part 2 (`8_5_ScriptWeekly.png`)
Completed min/max calculation loop and printed final results:

```bash
minimum=${week_fc[1]}
maximum=${week_fc[1]}
for item in ${week_fc[@]}; do
    if [[ $minimum > $item ]]
    then
        minimum=$item
    fi
    if [[ $maximum < $item ]]
    then
        maximum=$item
    fi
done

echo "minimum absolute error = $minimum"
echo "maximum absolute error = $maximum"
```

---

## Tools & Technologies Used
| Tool | Purpose |
|------|---------|
| `bash` | Shell scripting language |
| `curl` | Fetching live weather data from wttr.in |
| `grep`, `cut` | Text parsing and extraction |
| `tail`, `head` | Log file navigation |
| `date` | Timezone-aware date extraction |
| `nano` (GNU 6.2) | Script editing in terminal |
| Theia IDE | Cloud-based Linux terminal environment |

---

## Key Files
| File | Description |
|------|-------------|
| `rx_poc.sh` | Main weather extraction and logging script |
| `rx_poc.log` | Appended weather observation log |
| `fc_accuracy.sh` | Forecast accuracy computation script |
| `weekly_stats.sh` | Weekly min/max absolute error calculator |
| `historical_fc_accuracy.tsv` | Historical forecast accuracy data |
| `synthetic_historical_fc_accuracy.tsv` | Synthetic data used for weekly stats testing |
| `scratch.txt` | Temporary file for weekly stats extraction |
| `weather_report` | Raw weather output from wttr.in |

---

*Lab completed on April 25, 2026 | City: Casablanca, Morocco*
