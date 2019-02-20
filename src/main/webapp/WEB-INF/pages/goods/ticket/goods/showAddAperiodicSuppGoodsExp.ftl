<tr>
    <td colspan=3>有效期：</td>
</tr>
<tr>
    <td class="p_label">是否取票：</td>
    <td colspan=2>
        <input type="radio" name="takeFlag" value="N" checked="" />不取票 &nbsp;&nbsp;&nbsp;
        <input type="radio" name="takeFlag" value="Y" />取票
        <span id="takeDiv" style="display: none">
            <select name="takeType">
                <#list takeTimeTypeList as list>
                    <option value=${list.code!''}>${list.cnName!''}</option>
                </#list>
            </select>

            <span id="takeByPeriod">
                <input type="text" style="width:100px" name="takeStartTime" errorEle="selectDate" class="Wdate" id="takeStartTime" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'takeEndTime\',{d:0});}'})" required/>至
                <input type="text" style="width:100px" name="takeEndTime" errorEle="selectDate" class="Wdate" id="takeEndTime" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'takeStartTime\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'takeStartTime\',{d:0});}'})" required/>取票<div id="selectDateError" style="display:inline"></div></br>
            </span>
            <span id="takeByPoint" style="display: none">
                下单后
                <select name="takeDay" style="width:70px">
                    <option value="1">1(当)</option>
                    <#list 2..366 as i>
                        <option value="${i}">${i}</option>
                    </#list>
                </select>
                <select name="takeTimeType" style="width:70px">
                    <option value="DAY">天</option>
                    <option value="HOUR">小时</option>
                    <option value="MINUTE">分钟</option>
                </select>

                <span id="takeTimeHourAndMinute">
                    <input name="takeTime" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
                </span>
                <select name="takeAct" style="width:70px">
                    <#list actList as list>
                        <option value=${list.code!''}>${list.cnName!''}</option>
                    </#list>
                </select>取票,
                <div style="display: none" id="takeActTime">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="text" style="width:100px" name="takeDeadLineDay" errorEle="selectDate" class="Wdate" id="takeDeadLineDay" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}'})" required/>
                    <input name="takeDeadLineTime" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
                    截止取票。
                </div>
            </span>
        </span>
    </td>
</tr>

<tr>
    <td class="p_label"><i class="cc1">*</i>使用有效期：</td>
    <td colspan=2>
        <select name="useType" style="width:120px">
            <#list expTypeList as list>
                <option value=${list.code!''} <#if list.code=="TAKE_POINT">style="display: none"</#if>>${list.cnName!''}</option>
            </#list>
        </select>
        <span id="useByPeriod">
            <input type="text" style="width:100px" name="startTime" errorEle="selectDate" class="Wdate" id="d4321" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})" required/>至
            <input type="text" style="width:100px" name="endTime" errorEle="selectDate" class="Wdate" id="d4322" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4321\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:0});}'})" required/>内使用。（起止时间一样时，表示当天）<div id="selectDateError" style="display:inline"></div></br>
        </span>
        <span id="useByPoint" style="display: none">
            <span id="userText">下单后</span>
            <select name="useDay" style="width:70px">
                <option value="1">1(当)</option>
                <#list 2..366 as i>
                    <option value="${i}">${i}</option>
                </#list>
            </select>
            <select name="useTimeType" style="width:70px">
                <option value="DAY">天</option>
                <option value="HOUR">小时</option>
                <option value="MINUTE">分钟</option>
            </select>
            <span id="useTimeHourAndMinute">
                <input name="useTime" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
            </span>
            <select name="useAct" style="width:70px">
                <#list actList as list>
                    <option value=${list.code!''}>${list.cnName!''}</option>
                </#list>
            </select>使用，
            <div style="display: none" id="useActTime">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="text" style="width:100px" name="useDeadLineDay" errorEle="selectDate" class="Wdate" id="useDeadLineDay" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}'})" required/>
                <input name="useDeadLineTime" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
                截止使用。
            </div>
        </span>
    </td>
</tr>

<tr>
    <td class="p_label">期票商品不适用日期：</td>
    <td  colspan=2>
        <div>
            <table class="table_noborder">
                <tbody>
                <tr>
                    <td class="p_label"><input type="radio" name="isApplyDate" value="N" checked="" />无 &nbsp;&nbsp;&nbsp; <input type="radio" name="isApplyDate" value="Y" />有</td>
                    <td id="isApplyDateTd" style="display:none;">
                        <div>
                            <table class="table_noborder">
                                <tbody>
                                <tr>
                                    <td id="weeksExcludeTd"> <input type="checkbox" name="weeksExclude" value="Monday" />周一 <input type="checkbox" name="weeksExclude" value="Tuesday" />周二 <input type="checkbox" name="weeksExclude" value="Wednesday" />周三 <input type="checkbox" name="weeksExclude" value="Thursday" />周四 <input type="checkbox" name="weeksExclude" value="Friday" />周五 <input type="checkbox" name="weeksExclude" value="Saturday" />周六 <input type="checkbox" name="weeksExclude" value="Sunday" />周日 </td>
                                    <td id="datdExcludeTd" class="p_label">
                                        <div id="datdExcludeDiv">
                                            <table id="datdExcludeTable">
                                                <tbody>
                                                <tr>
                                                    <td> <input id="t4311" type="text" style="width:100px" name="datdExcludeStartTime" errorele="selectDate" class="Wdate" onfocus="WdatePicker({minDate:'%y-%M-{%d}'})" />
                                                        <input id="t4312" type="text" style="width:100px" name="datdExcludeEndTime" errorele="selectDate" class="Wdate" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'t4311\')||$dp.$D(\'d4321\')}',maxDate:'#F{$dp.$D(\'d4322\')}'})" />
                                                        <div id="selectDateError" style="display:inline"></div><br /> </td>
                                                    <td> <a href="#content" id="copyDatdExclude" name="copyDatdExclude">添加</a></td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </td>
    <input type="hidden" name="unvalidData" id="unvalidData" />
</tr>

<tr>
    <td class="p_label">使用次数：</td>
    <td colspan=2>
        <input type="text" name="useInsTruction" value="仅限使用1次" onFocus="if(value==defaultValue){value='';this.style.color='#000'}" onBlur="if(!value){value=defaultValue;this.style.color='#999'}" style="width:260px;color:#999999">
    </td>
</tr>