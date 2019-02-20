<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<style>

</style>
<form id="dataForm">
	<input type="hidden" name="messageId"  value="<#if multiLangMessageSetting??>${multiLangMessageSetting.messageId}</#if>" />
	<input type="hidden" name="messageSource" value="<#if messageSource??>${messageSource}</#if>" />
	
	<table class="p_table table_center">
		<tr>
			<td>英语</td>
			<td>
				
				<input type="text" maxlength="50" style="width: 300px;" name="messageEN" id="messageEN"  value="<#if multiLangMessageSetting??>${multiLangMessageSetting.messageEN}</#if>" />
			</td>
		</tr>
	
		<tr>
			<td>中文繁体</td>
			<td>
				<input type="text" maxlength="50" style="width: 300px;" name="messageTWCHN" id="messageTWCHN"  value="<#if multiLangMessageSetting??>${multiLangMessageSetting.messageTWCHN}</#if>" />
			</td>
		</tr>
	
		<tr>
			<td>韩语</td>
			<td>
				<input type="text" maxlength="50" style="width: 300px;" name="messageKOR" id="messageKOR"  value="<#if multiLangMessageSetting??>${multiLangMessageSetting.messageKOR}</#if>"/>
			</td>
		</tr>
	
		<tr>
			<td>日文</td>
			<td>
				<input type="text" maxlength="50" style="width: 300px;" name="messageJPN" id="messageJPN"  value="<#if multiLangMessageSetting??>${multiLangMessageSetting.messageJPN}</#if>"/>
			</td>
		</tr>
	</table>
	
	<div class="fl operate" style="margin:20px;width: 700px;" align="center">
			<a class="btn btn_cc1" id="save">保存</a>
	</div>
</form>	
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
$(function() {
	$('#save').bind('click',function(){
		
		var url = '/vst_admin/biz/bizTag/saveBizTagMultiLangSetting.do';
		
		var msg = '确定修改';
		$.confirm(msg,function(){
			$.ajax({
				url : url,
				type : "post",
				data : $("#dataForm").serialize(),
				success : function(result) {
					if(result.code=='success') {
						
						var setting = result.attributes.multiLangMessageSetting;
						$('#messageId',window.parent.document).val(setting.messageId);
						
						var linkText = '';
						var messageEN = $('#messageEN').val();
						var messageTWCHN = $('#messageTWCHN').val();
						var messageKOR = $('#messageKOR').val();
						var messageJPN = $('#messageJPN').val();
						
						if($.trim(messageEN) == '') {
							linkText += '英语,';
						} 
						
						if($.trim(messageTWCHN) == '') {
							linkText += '繁体中文,';
						}
						
						if($.trim(messageKOR) == '') {
							linkText += '韩文,';
						}
						
						if($.trim(messageJPN) == '') {
							linkText += '日文,';
						}
						
						if(linkText != '') {
							linkText = linkText.substring(0, linkText.length-1);
							linkText = '配置多语言[' + linkText + ']';
						} else {
							linkText = '配置多语言';
						}
						 
						$("a.editTextMultiLang", window.parent.document).text(linkText);
						
						$.alert(result.message,function() {
					 		
					 		parent.multiLangDialog.close();		
					 	});
					}
				  }
				});				
			});
	});
})
</script>