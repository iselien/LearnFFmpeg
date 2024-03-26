#!/bin/bash

#json='{"username"   :  "Evelyn"   ,"id":"306986359"    ,   "age":23 ,  "city":  "Bei Jing"}'
#json="{"uartCode": 101, "ssid":"elien", "pwd":"calmcalm"}"
json="{"uartCode": 101, "rts": 1 }"

echo $json

name=$(echo "$json" | awk -F '[:,}]' '{for(i=1;i<=NF;i++) if($i~/rts/){print $(i+1)}}' | sed 's/"//g') 

echo $name

# 
# name=$(echo "$json" | awk -F '[:,]')
# 
# echo $name
# 


# {"uartCode": 101, "ssid":"elien", "pwd":"calmcalm"}
# {"uartCode": 103, "WifiReset": 1 }
# {"uartCode": 104, "rts_url": "bb.gzmeow.com" }
# {"uartCode": 106, "ping": 1 }
# "{"uartCode": 108, "rts": 0 }"
# {"uartCode": 109, "restart": 1 }
# {"uartCode": 110, "AskSta": 1 }
# {"uartCode": 112, "Shutdown": 1 }
# {"uartCode": 113, "Mic": 1 }



# echo '{"field":"data", "array": ["i1", "i2"], "object":{"subfield":"subdata"}}' |
# grep -Eo '"[^"]*" *(: *([0-9]*|"[^"]*")[^{}\["]*|,)?|[^"\]\[\}\{]*|\{|\},?|\[|\],?|[0-9 ]*,?' |
# awk '{if ($0 ~ /^[}\]]/ ) offset-=4; printf "%*c%s\n", offset, " ", $0; if ($0 ~ /^[{\[]/) offset+=4}' "{"age": 10}"
# #  {
# #     "field":"data",
# #     "array":
# #     [
# #         "i1",

# #         "i2"
# #     ],

# #     "object":
# #     {
# #         "subfield":"subdata"
# #     }
# #  }

exit 0