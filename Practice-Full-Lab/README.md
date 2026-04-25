# Practice Full Lab – Weather Forecasting & Bash Scripting

## Overview
This full lab covers two parts: setting up a weather log from the command line,
and iteratively building Bash scripts to extract live weather data, compute
forecast accuracy, and calculate weekly statistics. All work was completed in
the Theia IDE on a Linux terminal. **Claude AI was utilized throughout this lab
to assist with troubleshooting script errors and to generate synthetic historical
data when additional data was needed to complete the weekly statistics portion of the lab.**

---

## Lab Objectives
In this lab, the following skills were learned and applied:

- Initialize a weather report log file
- Write a Bash script that downloads raw weather data, and extracts and loads the required data
- Schedule the Bash script `rx_poc.sh` to run every day at noon local time
- Apply advanced Bash scripting to produce reporting metrics
- Create a script to report historical forecasting accuracy
- Create a script to report the minimum and maximum absolute errors for the week

---

## Part 1: Practice Lab – Initial Setup & Data Pipeline

### 1. Initial Weather Log (`1Practice_InitialWeatherLog.png`)
- Created `rx_poc.log` using `touch` and made it executable with `chmod u+x`
- Defined a tab-separated header: `year`, `month`, `day`, `obs_temp`, `fc_temp`
- Wrote header into the log: `echo "$header" > rx_poc.log`
- Verified with `cat rx_poc.log`

### 2. Download Raw Weather Data (`2Project_DL-Raw-Weather_Data.png`)
- Created and made executable `rx_poc.sh`
- Set `city=Casablanca` and fetched live weather:
  `curl -s wttr.in/$city?T --output weather_report`
- Confirmed `weather_report` file was created

### 3. Extract & Load Data (`3Practice_Extract___Load_Data.png`)
- Ran `bash rx_poc.sh`
- Extracted:
  - Current Temperature of Casablanca: **64 °F**
  - Forecasted Temperature for noon tomorrow: **69 °F**
- Appended data as a new row into `rx_poc.log`

### 4. Historical Weather Log (`4_PracticeHistoricalWeather.png`)
- Created `historical_fc_accuracy.tsv` with columns:
  `year`, `month`, `day`, `obs_temp`, `fc_temp`, `accuracy`, `accuracy_range`
- Created `fc_accuracy.sh`
- Used `tail`, `head`, and `cut` to extract `yesterday_fc` from `rx_poc.log`

### 5. Forecast Accuracy Calculation (`5_PracticeAccuracy.png`)
- Appended historical entry: `2026 04 24 62 64` to `rx_poc.log`
- Computed: `accuracy=$(($yesterday_fc - $today_temp))` → **accuracy = -62**
- Debugged and fixed unary operator errors in `fc_accuracy.sh` with the help of **Claude AI**
- Final output: **Forecast accuracy is -62**

### 6. Head & Tail Verification (`Run_Head___Tail.png`)
- Refined and re-ran `fc_accuracy.sh`
- Resolved conditional logic errors on lines 10, 13, 16
- Clean output confirmed: **Forecast accuracy is -62**

### 7. Weekly Stats Run (`Run_Weekly.png`)
- Ran `weekly_stats.sh`
- **Claude AI was used to generate synthetic historical data** populated into
  `synthetic_historical_fc_accuracy.tsv` to provide enough data points for
  meaningful weekly analysis
- Output daily accuracy values: `-5, -1, -2, 4, -2, 0, 1, 5, 1, 2, 4, 2, 0, 1`
- Results:
  - **Minimum absolute error = 0**
  - **Maximum absolute error = 5**

---

## Part 2: Script Practice – Building rx_poc.sh Step by Step

### 1. Extract Current Temperature (`1_ScriptPractice.png`)
First version of `rx_poc.sh` — extracts observed temperature:

```bash
#!/bin/bash
city=Casablanca
obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 ' .' | grep -Eo -e '-?[[:digit:]].*')
echo "The current Temperature of $city: $obs_temp"
```

### 2. Add Forecast Temperature (`2_ScriptPractice.png`)
Extended script to also extract tomorrow's forecast:

```bash
fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep ' .' | cut -d 'C' -f2 | gr...)
echo "The forecasted temperature for noon tomorrow for $city : $fc_temp C"
```

### 3. Add Timezone & Date Variables (`3_ScriptrPractice.png`)
Added timezone and date extraction:

```bash
TZ='Morocco/Casablanca'
day=$(TZ='Morocco/Casablanca' date -u +%d)
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)
```

### 4. Full Script – Log the Record (`4_ScriptPractice.png`)
Assembled complete script with log append:

```bash
record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")
echo "$record">>rx_poc.log
```

### 5. Script Schedule – Logging Section (`5_ScriptSchedule.png`)
Confirmed final logging block intended for scheduled (cron) execution:

```bash
# Log the weather
record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")
echo "$record">>rx_poc.log
```

### 6. Historical Weather Setup (`6_ScriptHistoricalWeather.png`)
- Created `historical_fc_accuracy.tsv`
- Created `fc_accuracy.sh`
- Extracted `yesterday_fc` from log using `tail -2 | head -1 | cut`
- Log showed entries for **2026-04-25**: obs **64°F**, forecast **69°F**

### 7. Forecast Accuracy Script (`7_ScriptHead___Tail.png`)
Full `fc_accuracy.sh` with conditional accuracy ranges:

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

| Range | Condition |
|-------|-----------|
| `excellent` | -1 ≤ accuracy ≤ 1 |
| `good` | -2 ≤ accuracy ≤ 2 |
| `fair` | -3 ≤ accuracy ≤ 3 |
| `poor` | all others |

### 8. Weekly Stats – Part 1 (`8_ScriptWeekly.png`)
Extracts last 7 accuracy values and converts to absolute values:

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

### 9. Weekly Stats – Part 2 (`8_5_ScriptWeekly.png`)
Finds minimum and maximum absolute error:

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

## AI Assistance
**Claude AI (Anthropic)** was used during this lab for two purposes:
1. **Troubleshooting** — Helped identify and resolve Bash script errors,
   including unary operator issues in `fc_accuracy.sh` and logic debugging
   in `weekly_stats.sh`
2. **Synthetic Data Generation** — Generated realistic synthetic weather
   observation and forecast data to populate
   `synthetic_historical_fc_accuracy.tsv` when real historical data was
   insufficient for weekly statistics analysis

---

## Tools & Technologies Used
| Tool | Purpose |
|------|---------|
| `bash` | Shell scripting |
| `curl` | Fetching live weather data from wttr.in |
| `grep`, `cut` | Text parsing and extraction |
| `tail`, `head` | Log file navigation |
| `date` | Timezone-aware date extraction |
| `touch`, `chmod` | File creation and permissions |
| `nano` (GNU 6.2) | Script editing in terminal |
| Theia IDE | Cloud-based Linux terminal environment |
| Claude AI | Troubleshooting and synthetic data generation |

---

## Key Files
| File | Description |
|------|-------------|
| `rx_poc.sh` | Main weather extraction and logging script |
| `rx_poc.log` | Appended weather observation log |
| `fc_accuracy.sh` | Forecast accuracy computation script |
| `weekly_stats.sh` | Weekly min/max absolute error calculator |
| `historical_fc_accuracy.tsv` | Historical forecast accuracy data |
| `synthetic_historical_fc_accuracy.tsv` | Synthetic data for weekly stats testing |
| `scratch.txt` | Temporary file for weekly stats extraction |
| `weather_report` | Raw weather output from wttr.in |

---

*Lab completed on April 25, 2026 | City: Casablanca, Morocco*


