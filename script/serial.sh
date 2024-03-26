#!/bin/sh

debug="0"

#配置网络
setup_network() {
    ssid=$(echo "$command" | awk -F '[:,}]' '{for(i=1;i<=NF;i++) if($i~/ssid/){print $(i+1)}}' | sed 's/"//g' | sed 's/ //g')
    pwd=$(echo "$command" | awk -F '[:,}]' '{for(i=1;i<=NF;i++) if($i~/pwd/){print $(i+1)}}' | sed 's/"//g' | sed 's/ //g')

    if [ "$debug" = "1" ]
    then
        echo "param: ssid-$ssid, pwd-$pwd"
    fi

    echo "ctrl_interface=/var/run/wpa_supplicant
update_config=1
network={
        ssid=\"$ssid\"
        key_mgmt=WPA-PSK
        psk=\"$pwd\"
}" > /etc/wpa.conf

    ifconfig wlan0 up > /dev/null
    wpa_supplicant -B -Dnl80211 -iwlan0 -c/etc/wpa.conf > /dev/null
    udhcpc -i wlan0 > /dev/null


    result=$(ifconfig | grep -A 6 "wlan" | grep "inet addr")
    resultCode="201"
    if [ -n "$result" ]
    then
        resultCode="200"
    fi

    echo "{"uartCode": 101, "code": $resultCode}"
}

#重置网络
reset_network() {
    ifconfig wlan0 down > /dev/null
}

#保存推流地址
save_rts_url(){
    unset rts_url
    rts_url=$(echo "$command" | awk -F '[:,}]' '{for(i=1;i<=NF;i++) if($i~/rts_url/){print $(i+1)}}' | sed 's/"//g' | sed 's/ //g')
    if [ "$debug" = "1" ]
    then
        echo "param: rts_url-$rts_url"
    fi
}

#响应心跳
heartbeat(){
    echo "{"uartCode": 107, "ping": 2}"
}

#开始/停止直播
rtmp_live(){
    unset rts
    rts=$(echo "$command" | awk -F '[:,}]' '{for(i=1;i<=NF;i++) if($i~/rts/){print $(i+1)}}' | sed 's/"//g' | sed 's/ //g')
    if [ "$debug" = "1" ]
    then
        echo "param: rts_url-$rts_url, rts-$rts"
    fi

    unset pid
    pid=$(ps | grep rtmp | grep -v grep | awk '{print $1}')

    if [ "$rts" = "0" ]
    then
        if [ -n "$pid" ]
        then
            kill -9 "$pid"
        fi
        if [ -n "$rts_url" ]
        then
            rtmp "$rts_url" > /dev/null 2>&1 &
        fi
    elif [ "$rts" = "1" ]
    then
        if [ -n "$pid" ]
        then
            kill -9 "$pid"
        fi
    fi

}

#系统重启
system_restart(){
    reboot
}

#系统状态查询
system_status(){

    # 检查网络连接情况
    unset netResult
    netResult=$(ifconfig | grep -A 6 "wlan" | grep "inet addr")
    unset netResultCode
    netResultCode="1"
    if [ -n "$netResult" ]
    then
        netResultCode="0"
    fi

    # 检查推流程序状态
    unset cameraResult
    cameraResult=$(ps | grep rtmp | grep -v grep | awk '{print $1}')
    unset cameraResultCode
    cameraResultCode="1"
    if [ -n "$cameraResult" ]
    then
        cameraResultCode="0"
    fi

    echo "{"uartCode": 111, "data": {"net": $netResultCode, "camera": $cameraResultCode, "Mic": 0}}"
}

#系统关闭
system_shutdown(){
    poweroff
}

#麦克风开关
mic_switch(){
    if [ "$debug" = "1" ]
    then
        echo "todo -$command"
    fi
}

read command 
while [ "$command" != "exit" ]; do
    uartCode=$(echo "$command" | awk -F '[:,}]' '{for(i=1;i<=NF;i++) if($i~/uartCode/){print $(i+1)}}' | sed 's/"//g' | sed 's/ //g')
    if [ "$debug" = "1" ]
    then
        echo "command-$command"
        echo "uartCode-$uartCode"
    fi

    case "$uartCode" in
        101 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-单片机发送WiFi信息至摄像头"
            fi
            setup_network
            ;;
        103 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-删除网络"
            fi
            reset_network
            ;;
        104 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-发送摄像头推流地址"
            fi
            save_rts_url 
            ;;
        106 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-心跳包"
            fi
            heartbeat
            ;;
        108 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-开始/停止直播"
            fi
            rtmp_live 
            ;;
        109 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-摄像头重启"
            fi
            system_restart 
            ;;
        110 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-状态查询"
            fi
            system_status 
            ;;
        112 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-摄像头关机"
            fi
            system_shutdown
            ;;
        113 ) 
            if [ "$debug" = "1" ]
            then
                echo "action-开关麦克风"
            fi
            mic_switch 
            ;;
        * ) 
            if [ "$debug" = "1" ]
            then
                echo "$command command not found"
            fi
            ;;
    esac
    unset command
    read -r command 
done
exit 0