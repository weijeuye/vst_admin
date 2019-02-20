<#macro BuGenerator buList productBu categoryId subCategoryId>
	<select name="bu" id="bu" required categoryId="${categoryId}" subCategoryId="${subCategoryId}" >
	<option value="">请选择</option>
	<!--LOCAL_BU, DESTINATION_BU-->
	<#list buList as list>
	<option value=${list.code!''}
		<#if subCategoryId==181 && list.code=='TICKET_BU'>disabled="disabled"</#if>
		<#if productBu == list.code>selected</#if> >${list.cnName!''}
	</option>
	
	</#list>
	</select>
</#macro>
