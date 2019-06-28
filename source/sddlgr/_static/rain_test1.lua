function on_config()
    for i = 0,61 do
        set_global_number(i,0)
    end
    pwm_start("PWM_1",0)
end

function on_start()
    print('---on start-----')
    print(datetime())
    print(timestamp())
    add_data_item(0,1,'UCHAR',12)       
    add_data_item(0,2,'UCHAR',23)       
    add_data_item(0,3,'BCD_YYMMDDHHMM',bcdtime())

    bcd_time = bcdtime()
    if bcd_time[4] ==0 and bcd_time[5] == 0 then    --00:00
        set_global_number(61,0)
        print("clear today")
    end
    today_val = get_global_number(61)
    for i=2,60 do
        val = get_global_number(i)
        set_global_number(i-1,val)   
    end

    cnt = pwm_get("PWM_1")  --minute val
    pwm_set("PWM_1",0)
    print("minute")
    print(cnt)
    set_global_number(60,cnt)

    hour_total = 0          --hour val
    for i=1,60 do
        hour_total = hour_total + get_global_number(i)
    end
    print("hour")
    print(hour_total)
    --set_global_number(0,hour_total)

    today_val = today_val + cnt   --day val
    set_global_number(61,today_val)
    print("today")
    print(today_val)
 
    --Actual rainfall upload
    add_data_item(6,3,'SINT',cnt)
    add_data_item(6,2,'SINT',hour_total)
    add_data_item(6,1,'SINT',today_val)
end