<#if HAS_FETCH_LIMIT><#assign currentFetchLimitTime=ticketGoodsFormattedDesc.fetchLimit.timeLimitVOs[fetchTimeLimit_index] DISABLE_FLAG=false/><#else><#assign DISABLE_FLAG=true/></#if>
<div>
    <select class="w70 " name="fetchLimit.timeLimitVOs[${fetchTimeLimit_index}].startHour" <#if DISABLE_FLAG>disabled</#if>>
	<#list hourList as item>
		<#if HAS_FETCH_LIMIT && item==currentFetchLimitTime.startHour>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select> :
    <select class="w70 "  name="fetchLimit.timeLimitVOs[${fetchTimeLimit_index}].startMinute" <#if DISABLE_FLAG>disabled</#if>>
	<#list minuteList as item>
		<#if HAS_FETCH_LIMIT && item==currentFetchLimitTime.startMinute>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select> ~
    <select class="w70 "  name="fetchLimit.timeLimitVOs[${fetchTimeLimit_index}].endHour" <#if DISABLE_FLAG>disabled</#if>>
	<#list hourList as item>
		<#if HAS_FETCH_LIMIT && item==currentFetchLimitTime.endHour>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select> :
    <select class="w70" name="fetchLimit.timeLimitVOs[${fetchTimeLimit_index}].endMinute" <#if DISABLE_FLAG>disabled</#if>>
	<#list minuteList as item>
		<#if HAS_FETCH_LIMIT && item==currentFetchLimitTime.endMinute>
            <option value="${item}" selected="selected">${item}</option>
		<#else>
            <option value="${item}">${item}</option>
		</#if>
	</#list>
    </select>
      (<input type="text" <#if DISABLE_FLAG>disabled</#if> placeholder="此处填备注说明。无，可不填。" maxlength="50" name="fetchLimit.timeLimitVOs[${fetchTimeLimit_index}].remark" <#if HAS_FETCH_LIMIT>value="${currentFetchLimitTime.remark}"</#if>>)
    <a class="fetch_add addBtn btn <#if DISABLE_FLAG>disabled</#if>" style="cursor: pointer" data="${fetchTimeLimit_index}">增加</a><#t>
    <a class="fetch_delete deleteBtn btn <#if DISABLE_FLAG>disabled</#if>" style="cursor: pointer" data="${fetchTimeLimit_index}">删除</a><#t>
</div>
