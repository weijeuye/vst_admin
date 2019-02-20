<#assign mis=JspTaglibs["/WEB-INF/pages/tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_content">
<div >
    <p>以下项目均为必填</p>
    </div>
	<form method="post" action='/vst_admin/finance/goods/updateOrderRequired.do' id="reuqiredForm">
	<div class="p_box box_info">
		<input type="hidden" name="objectId" value="${suppGoodsId!''}">
	  	<input type="hidden" name="reqId" value="${comOrderRequired.reqId!''}">
	</div>
<!-- 主要内容显示区域\\ -->
    <div class="p_box box_info">
	<table class="p_table table_center">
        <tbody>
	            <tr class="js-check-box">
		            <td class="e_label" width="250"><i class="cc1">*</i>姓名：</td>
		            <td style="text-align:left;">需要&nbsp;&nbsp;</td>
		        </tr>
		        <tr class="js-check-box">
		        	<td class="e_label" width="250"><i class="cc1">*</i>手机号：</td>
		            <td style="text-align:left;">
		            	<input type="radio" name="phoneType" <#if comOrderRequired.phoneType=='Y'>checked</#if> value="Y" required=true>&nbsp;是
	            		<input type="radio" name="phoneType" <#if comOrderRequired.phoneType=='N'>checked</#if> value="N" required=true>&nbsp;否	
	            		<span id="telError"></span>
		            </td>
		        </tr>
		        <tr class="js-check-box">
		            <td class="e_label" width="250"><i class="cc1">*</i>E-mail：：</td>
		            <td style="text-align:left;">
		            	<input type="radio" name="emailType" <#if comOrderRequired.emailType=='Y'>checked</#if> value="Y" required=true>&nbsp;是
		        		<input type="radio" name="emailType" <#if comOrderRequired.emailType=='N'>checked</#if> value="N" required=true>&nbsp;否	
		        		<span id="emailError"></span>
		            </td>
		        </tr>
		        <tr class="js-check-box">
	        		<td class="e_label" width="250"><i class="cc1">*</i>证件：</td>
	            	<td style="text-align:left;">
		            	<input type="radio" name="credType" <#if comOrderRequired.credType=='Y'>checked</#if> value="Y" required=true>&nbsp;是
		        		<input type="radio" name="credType" <#if comOrderRequired.credType=='N'>checked</#if> value="N" required=true>&nbsp;否	<span id="certificatesError"></span>
		            	<br>
		            	<label><input type="checkbox"  name="idFlag"  <#if comOrderRequired.idFlag=='Y'>checked</#if> value="Y" >身份证</label>
		            	<label><input type="checkbox" name="passportFlag" <#if comOrderRequired.passportFlag=='Y'>checked</#if> value="Y" >护照</label>
		            	<label><input type="checkbox" name="passFlag" <#if comOrderRequired.passFlag=='Y'>checked</#if> value="Y" >港澳通行证</label>
		            	<label><input type="checkbox" name="twPassFlag"<#if comOrderRequired.twPassFlag=='Y'>checked</#if> value="Y" >台湾通行证</label>
		                <label><input type="checkbox" name="twResidentFlag"<#if comOrderRequired.twResidentFlag=='Y'>checked</#if> value="Y" >台胞证</label>
                        <label><input type="checkbox" name="householdRegFlag" <#if comOrderRequired.householdRegFlag=='Y'>checked</#if> value="Y" >户口簿</label>
		                <label><input type="checkbox" name="birthCertFlag" <#if comOrderRequired.birthCertFlag=='Y'>checked</#if> value="Y" >新生儿证明</label>
                        <label><input type="checkbox" name="soldierFlag" <#if comOrderRequired.soldierFlag=='Y'>checked</#if> value="Y" >士兵证</label>
                        <label><input type="checkbox" name="officerFlag" <#if comOrderRequired.officerFlag=='Y'>checked</#if> value="Y" >军官证</label>
		                <label><input type="checkbox" name="hkResidentFlag" <#if comOrderRequired.hkResidentFlag=='Y'>checked</#if> value="Y" >回乡证</label>
		            </td>
	        	</tr>
        <tr>
        	<td class="operate mt10" colspan="2" style="font-size: 16px;">
			    <a class="btn btn_cc1" id="btnSave">保存</a>
		    </td>
        </tr>     
        </tbody>
    </table>
	</div><!-- div p_box -->
</form>
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
$(function(){
	
	
    	if($("input[name='credType']:checked").val() === 'N'){
            $("input[name='credType']:checked").siblings('label').find('input').attr("disabled",true);
        }else{
           $("input[name='credType']:checked").siblings('label').find('input').attr("disabled",false);
        }	
	
});

	$("input[name=credType]").change(function(){
		var This =$(this);
		if($("input[name='credType']:checked").val() === 'Y'){
			This.siblings('label').find('input').attr("disabled",false);
		}else {
			This.siblings('label').find('input').attr("disabled",true);
		}
	});
	

//修改
$("#btnSave").click(function(){

    	if(!$("#reuqiredForm").validate().form()){
        	return false;
    	}
    	
    	if($("input[name='credType']:checked").val() === 'Y'){
			if(!$("input[name='idFlag']").is(":checked") && !$("input[name='passportFlag']").is(":checked") && !$("input[name='passFlag']").is(":checked") && !$("input[name='twPassFlag']").is(":checked")
				&& !$("input[name='twResidentFlag']").is(":checked") && !$("input[name='householdRegFlag']").is(":checked") && !$("input[name='birthCertFlag']").is(":checked")
				&& !$("input[name='soldierFlag']").is(":checked") && !$("input[name='officerFlag']").is(":checked") && !$("input[name='hkResidentFlag']").is(":checked")
			){
				$.msg("请勾选证件");
				return false;
			}
		}   
	var resultCode;
	$.ajax({
		url : "/vst_admin/finance/goods/updateOrderRequired.do",
		type : "post",
		data : $("#reuqiredForm").serialize(),
		dataType:'JSON',
		success : function(result) {
			if (result.code == "success") {
				$.alert(result.message,function(){
                        window.parent.orderRequierd.close();
                    });
            } else {
                $.msg(result.message, 3000);
            }
		},
		 error: function() {
		 	$.msg('保存失败', 3000);
		 }
	});
});

</script>