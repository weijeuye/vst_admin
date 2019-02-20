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
            <li class="active">修改产品条款</li>
        </ul>
</div>
<div class="iframe_content mt10">
<form action="/vst_admin/customized/packageTour/product/addProduct.do" method="post" id="dataForm">
       <div class="p_box box_info">
            <div class="box_content">
            	<table class="e_table form-inline">
	            	<tbody>
		                <tr>
		                	<td class="e_label"><span class="notnull"></span></td>
		                    <td>
		                   	 <input type="hidden" name="bizCategoryId" value="${prodProduct.bizCategory.categoryId}" required/>
		                     <input type="hidden" class="w35" name="productId" value="${prodProduct.productId}"   required>
		                    </td>
		                </tr>
	                </tbody>
                </table>
            </div>
        </div>
        	<!-- 条款品类属性分组Id -->
       		<#assign suggGroupIds = [26,27,28,29,30,31,32,33,63]/>  
 			<#assign productId="${prodProduct.productId}" />
  			<#assign index=0 />
 			<#list bizCatePropGroupList as bizCatePropGroup>
	            <#if (suggGroupIds?seq_contains(bizCatePropGroup.groupId)) && bizCatePropGroup.bizCategoryPropList?? && (bizCatePropGroup.bizCategoryPropList?size &gt; 0) >
		            <div class="p_box box_info">
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
							                <td width="150" class="e_label td_top" style="text-align:left" >
							                	<#if bizCategoryProp.nullFlag == 'Y'><span class="notnull">*</span></#if>
							                		<span>${bizCategoryProp.propName!''}</span>
							                	<#if bizCategoryProp.cancelFlag=='N'><span style="color:red" class="cancelProp">[无效]</span></#if>：
							                	<a class="btn btn_cc1" onclick="selectSuggList('${bizCategoryProp.suggestionCode}');selectIndex=parseInt($(this).attr('index'));"  style="background-color:#4D90FE;color:#FFFFFF;">建议内容</a>
							                </td>
						                </tr>
						                <tr>
					                	<td> <span class="${bizCategoryProp.inputType!''}" id="sugg${bizCategoryProp.suggestionCode}">     		
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
            <div class="fl operate">
            	<a class="btn btn_cc1" id="save">保存</a>
            	<a href="javascript:void(0);" class="btn btn_cc1 showLogDialog" param='objectId=${RequestParameters["productId"]}&objectType=PROD_PRODUCT_SUGG&sysName=VST'>查看操作日志</a>	
            </div>
        </div>
</form>
</div>
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
</body>
</html>
<script>
var suggSelectDialog;
var dataObj=[],markList=[];
$(function(){
	
    
    var index=0;
    
    $(".sensitiveVad").each(function(){
        var mark=$(this).attr('mark');
        $(this).closest('tr').prev('tr').find('a.btn').attr("index",index);
        var t = lvmamaEditor.editorCreate('mark',mark);
        dataObj.push(t);
        markList.push(mark);
        index++;
    });

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
    		
   			if(!$("#dataForm").validate({
	   			rules : {
	   					},
	   			messages : {
	   				
	   			}
   			}).form()){
   				return;
   			}
   			
   			for(var i=0;i<dataObj.length;i++){
                var temp = dataObj[i].html();
                $(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
            }
   			
   			if(!validateSensitiveVad()){
                return false;
            }
   			//设置附加属性的值
			refreshAddValue();
			
			var msg = '确认保存吗 ？';	
			 if(refreshSensitiveWord($("input[type='text'],textarea"))){
			 	msg = '内容含有敏感词,是否继续?'
			 }			
			
			$.confirm(msg,function(){
				var loading = top.pandora.loading("正在努力保存中...");
				$.ajax({
					url : "/vst_admin/customized/packageTour/product/updateProductSugg.do",
					type : "post",
					dataType : 'json',
					data : $("#dataForm").serialize(),
					success : function(result) {
						loading.close();
						pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						window.location.reload();
						}});
						
					},
					error : function(result) {
						loading.close();
						$.alert(result.message);
					}
				});
			});
			
			
	});
		
});

var selectSuggCode = "";
var selectIndex = -1;
//选择明细
function selectSuggList(suggCode){
	selectSuggCode = suggCode
    var url = "/vst_admin/biz/suggestionDetail/previewSuggDetail.do";
	suggSelectDialog = new xDialog(url,{"suggCode":suggCode,"reqDataFrom":"productSugg"}, {title:"条款选择",width:900,height:700});
	return false;
}

function setSuggTextArea(suggVal){
	suggSelectDialog.close();
//	if(selectSuggCode === "change_and_cancellation_instructions" || selectSuggCode === "warning" || selectSuggCode === "important"){
	if($("#sugg"+selectSuggCode).attr("class")=="INPUT_TYPE_RICH"){
		var p = suggVal.split("\n");
		for(var i=0;i<p.length;i++){
			if(selectIndex != -1){
				dataObj[selectIndex].insertHtml('<p>'+p[i]+'</p>');
			}
		}
	}else{
		var txt = $("#sugg"+selectSuggCode).find("textarea[name^='prodProductPropList']");
		txt.val(txt.val()+suggVal);
	}

}

function validateSensitiveVad(){
    var ret = true;
    
    $("textarea.sensitiveVad").each(function(index,element){
    	var str = $(element).text();
        var len = str.match(/[^ -~]/g) == null ? str.length : str.length + str.match(/[^ -~]/g).length ;
        var maxLength = $(element).attr("maxLength");
        if(len>maxLength){
            alert("超过最大长度"+maxLength);
            ret= false;
        }
    });
    return ret;
}

isView();
refreshSensitiveWord($("input[type='text'],textarea"));
</script>