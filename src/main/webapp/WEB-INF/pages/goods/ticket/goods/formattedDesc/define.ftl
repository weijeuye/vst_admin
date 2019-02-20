<div class="col">
    <input type="text" class="form-control w582 mr10" <#if NO_TYPE_DESC || NO_TYPE_DEFINES>disabled<#else>value="${typeDesc.defines[define_index]}"</#if> name="typeDesc.defines">
</div>
<a class="define_add addBtn btn <#if NO_TYPE_DESC || NO_TYPE_DEFINES>disabled</#if>" style="cursor: pointer" data="${define_index}" >增加</a><#t>
<a class="define_delete deleteBtn btn <#if NO_TYPE_DESC || NO_TYPE_DEFINES>disabled</#if>" style="cursor: pointer" data="${define_index}" >删除</a><#t>
