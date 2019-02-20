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
	<table class="p_table form-inline">
		<tr>
			<td>英语</td>
			<td>
				<textarea name="messageEN" class="textWidth" maxlength="500" style="margin: 0px; width: 750px; height: 38px;" id="messageEN"><#if multiLangMessageSetting??>${multiLangMessageSetting.messageEN}</#if></textarea>
			</td>
		</tr>
	
		<tr>
			<td>中文繁体</td>
			<td>
				<textarea name="messageTWCHN" class="textWidth" maxlength="500" style="margin: 0px; width: 750px; height: 38px;" id="messageTWCHN"><#if multiLangMessageSetting??>${multiLangMessageSetting.messageTWCHN}</#if></textarea>
			</td>
		</tr>
	
		<tr>
			<td>韩语</td>
			<td>
				<textarea name="messageKOR" class="textWidth" maxlength="500" style="margin: 0px; width: 750px; height: 38px;" id="messageKOR"><#if multiLangMessageSetting??>${multiLangMessageSetting.messageKOR}</#if></textarea>
			</td>
		</tr>
	
		<tr>
			<td>日文</td>
			<td>
				<textarea  name="messageJPN" class="textWidth" maxlength="500" style="margin: 0px; width: 750px; height: 38px;" id="messageJPN"><#if multiLangMessageSetting??>${multiLangMessageSetting.messageJPN}</#if></textarea>
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

	//限制字数
	$(".textWidth[maxlength]").each(function() {
		var	maxlen = $(this).attr("maxlength");
		if(maxlen != null && maxlen != ''){
			var l = maxlen*12;
			if(l >= 700) {
				l = 500;
			} else if (l <= 200){
				l = 200;
			} else {
				l = 200;
			}
			$(this).width(l);
		}
		
		$(this).keyup(function() {
			vst_util.countLenth($(this));
		});
	});
	
		
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
						$('#memoMessageId',window.parent.document).val(setting.messageId);
						
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
						 
						$("a.editTagNameMemoMultiLang", window.parent.document).text(linkText);
						
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