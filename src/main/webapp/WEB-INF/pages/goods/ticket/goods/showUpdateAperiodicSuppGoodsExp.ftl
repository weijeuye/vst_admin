<tr>
    <td colspan=3>有效期：</td>
</tr>

<tr>
    <td class="p_label">是否取票：</td>
    <td colspan=2>
        <input type="hidden" name="expId" value=${suppGoodsExp.expId}>
        <input type="radio" name="takeFlag" value="N" <#if suppGoodsExp.takeFlag=="N">checked="checked"</#if> />不取票 &nbsp;&nbsp;&nbsp;
        <input type="radio" name="takeFlag" value="Y" <#if suppGoodsExp.takeFlag=="Y">checked="checked"</#if>/>取票
        <span id="takeDiv" <#if suppGoodsExp.takeFlag=="N">style="display: none"</#if>>
            <select name="takeType">
                <#list takeTimeTypeList as list>
                    <option value=${list.code!''} <#if suppGoodsExp.takeType==list.code>selected="selected"</#if>>${list.cnName!''}</option>
                </#list>
            </select>

            <span id="takeByPeriod" <#if suppGoodsExp.takeType=="POINT">style="display: none"</#if>>
                <input type="text" style="width:100px" name="takeStartTime" errorEle="selectDate" class="Wdate" id="takeStartTime" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'takeEndTime\',{d:0});}'})" value="${suppGoodsExp.takeStartTimeStr}" required/>至
                <input type="text" style="width:100px" name="takeEndTime" errorEle="selectDate" class="Wdate" id="takeEndTime" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'takeStartTime\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'takeStartTime\',{d:0});}'})" value="${suppGoodsExp.takeEndTimeStr}" required/>取票<div id="selectDateError" style="display:inline"></div></br>
            </span>
            <span id="takeByPoint" <#if suppGoodsExp.takeType=="PERIOD">style="display: none"</#if>>
                下单后
                <select name="takeDay" style="width:70px">
                    <option value="1" <#if suppGoodsExp.takeDay==1>selected="selected"</#if>>1(当)</option>
                <#list 2..366 as i>
                    <option value="${i}" <#if suppGoodsExp.takeDay==i>selected="selected"</#if>>${i}</option>
                </#list>
                </select>
                <select name="takeTimeType" style="width:70px">
                    <option value="DAY" <#if suppGoodsExp.takeTimeType=="DAY">selected="selected"</#if>>天</option>
                    <option value="HOUR" <#if suppGoodsExp.takeTimeType=="HOUR">selected="selected"</#if>>小时</option>
                    <option value="MINUTE" <#if suppGoodsExp.takeTimeType=="MINUTE">selected="selected"</#if>>分钟</option>
                </select>

                <span id="takeTimeHourAndMinute" <#if suppGoodsExp.takeTimeType!="DAY">style="display: none"</#if>>
                    <input name="takeTime" value="${suppGoodsExp.takeTime}" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
                </span>
                <select name="takeAct" style="width:70px">
                <#list actList as list>
                    <option value=${list.code!''} <#if suppGoodsExp.takeAct=="${list.code}">selected="selected"</#if>>${list.cnName!''}</option>
                </#list>
                </select>取票,
                <div id="takeActTime" <#if suppGoodsExp.takeAct=="INNER">style="display: none"</#if>>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="text" style="width:100px" name="takeDeadLineDay" value="${suppGoodsExp.takeDeadLineDayStr}" errorEle="selectDate" class="Wdate" id="takeDeadLineDay" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}'})" required/>
                    <input name="takeDeadLineTime" value="${suppGoodsExp.takeDeadLineTime}" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
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
                    <option value=${list.code!''} <#if suppGoodsExp.useType=="${list.code}">selected="selected"</#if>>${list.cnName!''}</option>
            </#list>
        </select>
        <span id="useByPeriod" <#if suppGoodsExp.useType!="PERIOD">style="display: none"</#if>>
            <input type="text" style="width:100px" name="startTime" value="${suppGoodsExp.startTimeStr}" errorEle="selectDate" class="Wdate" id="d4321" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})" required/>至
            <input type="text" style="width:100px" name="endTime" value="${suppGoodsExp.endTimeStr}" errorEle="selectDate" class="Wdate" id="d4322" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4321\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:0});}'})" required/>内使用。（起止时间一样时，表示当天）<div id="selectDateError" style="display:inline"></div></br>
        </span>
        <span id="useByPoint" <#if suppGoodsExp.useType=="PERIOD">style="display: none"</#if>>
            <span id="userText">下单后</span>
            <select name="useDay" style="width:70px">
                <option value="1" <#if suppGoodsExp.useDay==1>selected="selected"</#if>>1(当)</option>
                <#list 2..366 as i>
                    <option value="${i}" <#if suppGoodsExp.useDay==i>selected="selected"</#if>>${i}</option>
                </#list>
            </select>
            <select name="useTimeType" style="width:70px">
                <option value="DAY" <#if suppGoodsExp.useTimeType=="DAY">selected="selected"</#if>>天</option>
                <option value="HOUR" <#if suppGoodsExp.useTimeType=="HOUR">selected="selected"</#if>>小时</option>
                <option value="MINUTE" <#if suppGoodsExp.useTimeType=="MINUTE">selected="selected"</#if>>分钟</option>
            </select>
            <span id="useTimeHourAndMinute" <#if suppGoodsExp.useTimeType!="DAY">style="display: none"</#if>>
                <input name="useTime" value="${suppGoodsExp.useTime}" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
            </span>
            <select name="useAct" style="width:70px">
                <#list actList as list>
                    <option value=${list.code!''} <#if suppGoodsExp.useAct=="${list.code}">selected="selected"</#if>>${list.cnName!''}</option>
                </#list>
            </select>使用，
            <div id="useActTime" <#if suppGoodsExp.useAct=="INNER">style="display: none"</#if>>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="text" style="width:100px" name="useDeadLineDay" value="${suppGoodsExp.useDeadLineDayStr}" errorEle="selectDate" class="Wdate" id="useDeadLineDay" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}'})" required/>
                <input name="useDeadLineTime"value="${suppGoodsExp.useDeadLineTime}" type="text" class="txt" onfocus="WdatePicker({ dateFmt: 'HH:mm' })"/>
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
                    <td class="p_label">
                        <input type="radio" name="isApplyDate" value="N" <#if suppGoodsExp?? && (suppGoodsExp.unvalidData==""||suppGoodsExp.unvalidData==null)>checked</#if> />无 &nbsp;&nbsp;&nbsp; <input type="radio" name="isApplyDate" value="Y" <#if suppGoodsExp?? && (suppGoodsExp.unvalidData!=""&&suppGoodsExp.unvalidData!=null)>checked</#if> />有</td>
                    <td id="isApplyDateTd" <#if suppGoodsExp?? &&(suppGoodsExp.unvalidData==""||suppGoodsExp.unvalidData==null)>style="display:none;"</#if>>
                        <#if suppGoodsExp?? && suppGoodsExp.unvalidData?? >
                            <#assign unvalidData>${suppGoodsExp.unvalidData}</#assign>
                            <#assign unvalidDataJson=unvalidData?eval />
                            <div>
                                <table class="table_noborder">
                                    <tbody>
                                    <tr>
                                        <td id="weeksExcludeTd">
                                            <INPUT type="checkbox" name="weeksExclude" value="Monday"      <#list unvalidDataJson.weeks as item><#if item?? && item=='Monday'>checked="checked"</#if></#list>>周一
                                            <INPUT type="checkbox" name="weeksExclude" value="Tuesday"     <#list unvalidDataJson.weeks as item><#if item?? && item=='Tuesday'>checked="checked"</#if></#list>>周二
                                            <INPUT type="checkbox" name="weeksExclude" value="Wednesday"   <#list unvalidDataJson.weeks as item><#if item?? && item=='Wednesday'>checked="checked"</#if></#list>>周三
                                            <INPUT type="checkbox" name="weeksExclude" value="Thursday"    <#list unvalidDataJson.weeks as item><#if item?? && item=='Thursday'>checked="checked"</#if></#list>>周四
                                            <INPUT type="checkbox" name="weeksExclude" value="Friday"      <#list unvalidDataJson.weeks as item><#if item?? && item=='Friday'>checked="checked"</#if></#list>>周五
                                            <INPUT type="checkbox" name="weeksExclude" value="Saturday"    <#list unvalidDataJson.weeks as item><#if item?? && item=='Saturday'>checked="checked"</#if></#list>>周六
                                            <INPUT type="checkbox" name="weeksExclude" value="Sunday"      <#list unvalidDataJson.weeks as item><#if item?? && item=='Sunday'>checked="checked"</#if></#list>>周日
                                        </td>
                                        <td id="datdExcludeTd" class="p_label">
                                            <div id="datdExcludeDiv">
                                                <table id="datdExcludeTable">
                                                    <tbody>
                                                    <tr>
                                                        <td>
                                                            <#if (unvalidDataJson.dateScope?size > 0)>
                                                                <#list unvalidDataJson.dateScope as item >
                                                                    <#if item_index=0>
                                                                        <input id="t4311" type="text" style="width:100px" name="datdExcludeStartTime" errorEle="selectDate" class="Wdate" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4321\')}',maxDate:'#F{$dp.$D(\'t4312\')||$dp.$D(\'d4322\')}'})"   value="${item.startDate}"/>
                                                                        <input id="t4312" type="text" style="width:100px" name="datdExcludeEndTime" errorEle="selectDate" class="Wdate"  onFocus="WdatePicker({minDate:'#F{$dp.$D(\'t4311\')||$dp.$D(\'d4321\')}',maxDate:'#F{$dp.$D(\'d4322\')}'})"    value="${item.endDate}" />
                                                                    </#if>
                                                                </#list>
                                                            <#else>
                                                                <input id="t4311" type="text" style="width:100px" name="datdExcludeStartTime" errorEle="selectDate" class="Wdate" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4321\')}',maxDate:'#F{$dp.$D(\'t4312\')||$dp.$D(\'d4322\')}'})"/>
                                                                <input id="t4312" type="text" style="width:100px" name="datdExcludeEndTime" errorEle="selectDate" class="Wdate"  onFocus="WdatePicker({minDate:'#F{$dp.$D(\'t4311\')||$dp.$D(\'d4321\')}',maxDate:'#F{$dp.$D(\'d4322\')}'})"/>
                                                            </#if>
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
                        <#else>
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
                                                            <input id="t4312" type="text" style="width:100px" name="datdExcludeEndTime" errorele="selectDate" class="Wdate" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'t4311\')||$dp.$D(\'d4321\')}'})" />
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
                        </#if>
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
        <input type="text" name="useInsTruction" value="<#if suppGoodsExp?? && suppGoodsExp.useInsTruction??>${suppGoodsExp.useInsTruction}<#else>仅限使用1次</#if>" onFocus="if(value==defaultValue){value='';this.style.color='#000'}" onBlur="if(!value){value=defaultValue;this.style.color='#999'}" style="width:260px;color:#999999">
    </td>
</tr>