<#if HAS_VISIT_LIMIT><#assign currentVisitLimitTime=ticketGoodsFormattedDesc.visitLimit.timeLimitVOs[visitTimeLimit_index]/><#else><#assign DISABLE_FLAG=true/></#if>
<div>
    <select class="w70 " name="visitLimit.timeLimitVOs[${visitTimeLimit_index}].startHour" <#if DISABLE_FLAG>disabled</#if>>
	<#list hourList as item>
		<#if HAS_VISIT_LIMIT && item==currentVisitLimitTime.startHour>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select> :
    <select class="w70 "  name="visitLimit.timeLimitVOs[${visitTimeLimit_index}].startMinute" <#if DISABLE_FLAG>disabled</#if>>
	<#list minuteList as item>
		<#if HAS_VISIT_LIMIT && item==currentVisitLimitTime.startMinute>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select> ~
    <select class="w70 " name="visitLimit.timeLimitVOs[${visitTimeLimit_index}].endHour" <#if DISABLE_FLAG>disabled</#if>>
	<#list hourList as item>
		<#if HAS_VISIT_LIMIT && item==currentVisitLimitTime.endHour>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select> :
    <select class="w70"  name="visitLimit.timeLimitVOs[${visitTimeLimit_index}].endMinute" <#if DISABLE_FLAG>disabled</#if>>
	<#list minuteList as item>
		<#if HAS_VISIT_LIMIT && item==currentVisitLimitTime.endMinute>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select>
      (<input type="text" placeholder="此处填备注说明。无，可不填。" <#if DISABLE_FLAG>disabled</#if> maxlength="50" name="visitLimit.timeLimitVOs[${visitTimeLimit_index}].remark" <#if HAS_VISIT_LIMIT>value="${currentVisitLimitTime.remark}"</#if>>)
    <a class="visit_add addBtn btn <#if DISABLE_FLAG>disabled</#if>" style="cursor: pointer" data="${visitTimeLimit_index}">增加</a><#t>
    <a class="visit_delete deleteBtn btn <#if DISABLE_FLAG>disabled</#if>" style="cursor: pointer" data="${visitTimeLimit_index}">删除</a><#t>
</div>
