<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findProductInputType.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>

</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">${prodProduct.bizCategory.categoryName}</a> &gt;</li>
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">修改其他产品</li>
        </ul>
</div>
<div class="iframe_content mt10">
<div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>注：产品创建后，不能变更所属的品类</div>
<form action="/vst_admin/other/prod/product/addProduct.do" method="post" id="dataForm">
<input type="hidden" name="senisitiveFlag" value="N">
       <div class="p_box box_info p_line">
            <div class="box_content">
            <table class="e_table form-inline">
            <tbody>
                <tr>
                	<td width='150' class="e_label"><span class="notnull">*</span>所属品类：</td>
                	<td>
                		<input type="hidden" name="bizCategoryId" value="${prodProduct.bizCategory.categoryId}" required>
                		<input type="hidden" name="categoryName" value="${prodProduct.bizCategory.categoryName}">
                		${prodProduct.bizCategory.categoryName}
                	</td>
                </tr>
                <tr>
                	<td class="e_label"><span class="notnull">*</span>其他产品ID：</td>
                    <td>
                    	<input type="text" class="w35" name="productId" value="${prodProduct.productId}" readonly="readonly">
                    </td>
                </tr>
				<tr>
                	<td class="e_label"><span class="notnull">*</span>产品名称：</td>
                    <td>
                    	<label><input type="text" class="w35" style="width:700px" name="productName" id="productName" maxLength=50 value="${prodProduct.productName}" required>&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
                    	<div id="productNameError"></div>
                    </td>
                </tr>
               	<tr>
					<td class="e_label"><span class="notnull">*</span>状态：</td>
					<td><#if prodProduct.cancelFlag == 'Y'>有效<#else>无效</#if>
						<#--<select name="cancelFlag" required>-->
			                    <#--<option value='Y' <#if prodProduct.cancelFlag == 'Y'>selected</#if> >是</option>-->
			                    <#--<option value='N' <#if prodProduct.cancelFlag == 'N'>selected</#if> >否</option>-->
	                    <#--</select>-->
	                    <div id="cancelFlagError"></div>
                   	</td>
                </tr>
                <tr>
					<td class="e_label"><span class="notnull">*</span>推荐级别：</td>
					<td>
					  <label>
						<select name="recommendLevel" required>
	                    	<option value="5" <#if prodProduct.recommendLevel == '5'>selected</#if> >5</option>
	                    	<option value="4" <#if prodProduct.recommendLevel == '4'>selected</#if> >4</option>
	                    	<option value="3" <#if prodProduct.recommendLevel == '3'>selected</#if> >3</option>
	                    	<option value="2" <#if prodProduct.recommendLevel == '2'>selected</#if> >2</option>
	                    	<option value="1" <#if prodProduct.recommendLevel == '1'>selected</#if> >1</option>
	                    </select>
	                    	说明：由高到低排列，即数字越高推荐级别越高
	                   </label> 
	                   <div id="recommendLevelError"></div>
                    </td>
                </tr>
                <tr>
	                	<td class="e_label"><i class="cc1">*</i>类别：</td>
	                 	 <td>
                  			<#list productTypeList as list>
								<input type="radio" name="productType" value="${list.code!''}" required  <#if prodProduct.productType == list.code>checked</#if> />${list.cnName!''}
               	 			</#list>
	                    	<div id="productTypeError"></div>
	                    </td>
	                </tr>
                </table>
            </div>
        </div>
        
 			<#assign productId="${prodProduct.productId}" />
  			<#assign index=0 />
 			<#list bizCatePropGroupList as bizCatePropGroup>
            <#if bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size &gt; 0)>
            <div class="p_box box_info">
            <div class="title">
			    <h2 class="f16">${bizCatePropGroup.groupName!''}：</h2>
		    </div>
            <div class="box_content">
            <table class="e_table form-inline">
             	<tbody>
             		<#list bizCatePropGroup.bizCategoryPropList as bizCategoryProp>
                		<#if (bizCategoryProp??)>
                		
                		<#assign disabled='' />
                		<#if bizCategoryProp.cancelFlag=='N'>
                			<#assign disabled='disabled' />
                		</#if>
                		<#assign prodPropId='' />
                		<#assign propId=bizCategoryProp.propId />
                		<#if bizCategoryProp?? && bizCategoryProp.prodProductPropList[0]!=null>
	                		<#assign prodPropId=bizCategoryProp.prodProductPropList[0].prodPropId />
                		</#if>
	                	<tr>
		                <td width="150" class="e_label td_top">
		                	<#if bizCategoryProp.nullFlag == 'Y'><span class="notnull">*</span></#if>
		                	${bizCategoryProp.propName!''}
		                	<#if bizCategoryProp.cancelFlag=='N'><span style="color:red" class="cancelProp">[无效]</span></#if>：
		                </td>
	                	<td> <span class="${bizCategoryProp.inputType!''}" propId = "${propId }">     		
	                		<input type="hidden" name="prodProductPropList[${index}].prodPropId" value="${prodPropId}" ${disabled}  />
	                		<input type="hidden" name="prodProductPropList[${index}].propId" value="${propId}" ${disabled} />
	                		<!-- 調用通用組件 -->
	                		<@displayHtml productId index bizCategoryProp  />
	                		
	                		<div id="errorEle${index}Error" style="display:inline"></div>
	                		<span style="color:grey">${bizCategoryProp.propDesc!''}</span>
	        				</span></td>
		        		</tr>
		              </#if>
		               <#assign index=index+1 />
                	</#list>
                	</tbody>
                </table>
            </div>
        </div>
        </#if>
		</#list>
         
        <div class="p_box box_info clearfix mb20">
            <div class="fl operate"><a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a></div>
        </div>
</form>
</div>
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/ckeditor/ckeditor.js"></script>
</body>
</html>
<script>

$(function(){

//JQuery 自定义验证
jQuery.validator.addMethod("isCharCheck", function(value, element) {
    var chars =  /^([\u4e00-\u9fa5]|[a-zA-Z0-9]|[\+-]|[\u0020])+$/;//验证特殊字符  
    return this.optional(element) || (chars.test(value));       
 }, "不可为空或者特殊字符");
 
	$("#save").bind("click",function(){
	 
		$.each(CKEDITOR.instances, function(i, n){
			$(".ckeditor").each(function(){
				if($(this).attr('name')==n.name){
					$(this).text(n.getData());
					if($(this).attr("data")=="YY")
					$(this).attr("required","true")
				}
			});
		}); 
		//验证
		if(!$("#dataForm").validate({
			rules : {
				productName : {
					isCharCheck : true
				}
			},
			messages : {
				productName : '不可为空或者特殊字符'
			}
		}).form()){
			return;
		};
		
		var msg = '确认保存吗 ？';	
	    if(refreshSensitiveWord($("input[type='text'],textarea"))){
	     $("input[name=senisitiveFlag]").val("Y");
	 	 msg = '内容含有敏感词,是否继续?';
	   }else {
			$("input[name=senisitiveFlag]").val("N");
	}
		
		$.confirm(msg,function(){
			var loading = top.pandora.loading("正在努力保存中...");
			//设置附加属性的值
			refreshAddValue();
			
			$.ajax({
				url : "/vst_admin/other/prod/product/updateProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
						parent.checkAndJump();
					}});
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
		});	
	});
		
	$("#saveAndNext").bind("click",function(){
		 $.each(CKEDITOR.instances, function(i, n){
			$(".ckeditor").each(function(){
				if($(this).attr('name')==n.name){
					$(this).text(n.getData());
					if($(this).attr("data")=="YY")
					$(this).attr("required","true")
				}
			});
		}); 
		//验证
		if(!$("#dataForm").validate({
			rules : {
				productName : {
					isCharCheck : true
				}
			},
			messages : {
				productName : '不可为空或者特殊字符'
			}
		}).form()){
			return;
		};
		 
		 var msg = '确认修改吗 ？';	
	    if(refreshSensitiveWord($("input[type='text'],textarea"))){
	     $("input[name=senisitiveFlag]").val("Y");
	 	 msg = '内容含有敏感词,是否继续?';
	   }else {
			$("input[name=senisitiveFlag]").val("N");
	}
		 
		$.confirm(msg, function () {
			var loading = top.pandora.loading("正在努力保存中...");
			//设置附加属性的值
			refreshAddValue();
			
			$.ajax({
				url : "/vst_admin/other/prod/product/updateProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					alert(result.message);
					var productId = $("input[name='productId']").val();
					var categoryId = $("input[name='bizCategoryId']").val();
					$(".pg_title", parent.document).html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("input[name='productName']").val()+"   "+"品类:"+$("input[name='categoryName']").val()+"   "+"产品ID："+$("input[name='productId']").val());
					window.location.href="/vst_admin/other/prod/prodbranch/findProductBranchList.do?productId="+productId+"&categoryId="+categoryId;
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
		});
	});	
});	
 
refreshSensitiveWord($("input[type='text'],textarea"));
</script>