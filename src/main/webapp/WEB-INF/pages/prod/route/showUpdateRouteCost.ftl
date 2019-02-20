<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findProductInputType.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>

</head>
<body>
<input type="hidden" id="noEditFlag" name="noEditFlag" <#if noEditFlag??> value="${noEditFlag}"<#else>value="false"</#if>>
<input type="hidden" id="modelVersion" neme = "modelVersion" value="${modelVersion}">
<div class="iframe_header">
    <ul class="iframe_nav">
       <li><a href="#">${prodProduct.bizCategory.categoryName!''}</a> &gt;</li>
        <li><a href="#">${packageType!''}</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">行程</li>
    </ul>
</div> 

<div class="iframe_content mt15">
	<span style="font-weight:bold;font-size:15px;">行程展示：${prodLineRoute.routeName}</span>
	<a style="font-size:13px;margin-left:10px;" href="/vst_admin/prod/prodLineRoute/showUpdateRoute.do?productId=${prodProduct.productId}&oldProductId=${oldProductId}">返回行程</a>
	<#if noEditFlag == "true"><a  href="javascript:void(0);" id="toEdit">编辑费用</a></#if>
</div>

<form action="/vst_admin/prod/prodLineRoute/editprodroutecost.do" method="post" id="dataForm">
		<input type="hidden" name="lineRouteId" value="${prodLineRoute.lineRouteId}" />
       <div class="p_box box_info p_line" style="margin-left: 20px;">
            <div class="box_content">
	           <table class="e_table form-inline">
	           	<tbody>
	           		<tr>
           			<td>
           				费用包含：<a class="btn btn_cc1 sugg" data="fee_includes" flag="include" style="background-color:#4D90FE;color:#FFFFFF;">建议内容</a>
					</td>
					</tr>
					<tr>
					<td> 
						<span class="INPUT_TYPE_TEXTAREA">   
      					<textarea class="w35 textWidth" style="width: 700px; height: 80px; margin:0px;" errorele="errorEle3" id="include" name="include" maxlength="3500">${prodLineRoute.costInclude!''}</textarea>
				        <div id="errorEle3Error" style="display:inline"></div>
				        <span style="color:grey"></span>
				        </span>
					 </td>
					</tr>
					<tr>
           			<td>
           				费用不包含：<a class="btn btn_cc1 sugg" data="cost_free" flag="exclude" style="background-color:#4D90FE;color:#FFFFFF;">建议内容</a>
					</td>
					</tr>
					<tr>
					<td> 
						<span class="INPUT_TYPE_TEXTAREA">     		
      					<textarea class="w35 textWidth" style="width: 700px; height: 80px;" errorele="errorEle3" id="exclude" name="exclude" maxlength="3500">${prodLineRoute.costExclude!''}</textarea>
				        <div id="errorEle3Error" style="display:inline"></div>
				        <span style="color:grey"></span>
				        </span>
					 </td>
					</tr>
		         </tbody>
				</table>
            </div>
         </div>
         
         <div class="p_box box_info clearfix mb20" >
            <div class="fl operate" >
            	<a class="btn btn_cc1" id="save">保存</a>
            </div>
        </div>
</form>

</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
var flagObj;
var suggSelectDialog;
$(function(){
	//页面关联则不可修改
	var $document = $(document);

    //页面加载时检测敏感词
    refreshSensitiveWord($("textarea"));
  	
	 if($("#noEditFlag").val() == "true"){
	     	$document.unbind();
	       	$("input[type='radio']").attr("disabled",true);
	       	$("input[type='checkbox']").attr("disabled",true);
	       	$("input").attr("readonly",true);
	//      $("div.iframe_content.mt15 a").removeAttr("href");
	       	$("#include").attr("readonly",true);
	       	$("#exclude").attr("readonly",true);
	 }else{
			$("#save").bind("click", function() {
                var message = "确定保存?";
                //保存时再次检测敏感词，refreshSensitiveWord使用的是同步请求，所以会阻塞至调用完成
                if (refreshSensitiveWord($("textarea"))) {
                    message = "存在敏感词，继续保存？";
                    //此处不修改标识产品是否包含敏感词；
                }
                $.confirm(message, function () {
                        $.ajax({
                            url : "/vst_admin/prod/prodLineRoute/editprodroutecost.do",
                            type : "post",
                            dataType : 'json',
                            data : $("#dataForm").serialize(),
                            success : function(result) {
                                pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                                      $("#saveRouteFlag",window.parent.document).val('true');
                                      $("#route",parent.document).parent("li").trigger("click");
                                }});
                            },
                            error : function(result) {
                                $.alert(result.message);
                            }
                        });
                });
			  });
			$(".sugg").bind("click", function(){
				flagObj = $(this).attr("flag");
				suggCode = $(this).attr("data");
				var url = "/vst_admin/biz/suggestionDetail/previewSuggDetail.do";
				suggSelectDialog = new xDialog(url,{"suggCode":suggCode,"reqDataFrom":"productSugg"}, {title:"条款选择",width:900,height:700});
				return false;
			});
	}
	

	$("#toEdit").click(function () {
		if($("#modelVersion").val() == "true"){
			var url = "/vst_admin/dujia/group/route/cost/editProdRouteCost.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}&productType=${productType}";
		}else{
			var url = "/vst_admin/prod/prodLineRoute/editprodroutecost.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}";
		}
		var editDialog = new xDialog(url,{},{title:"编辑费用说明",iframe:true, width:1000, height:450});
		return;
	  });
	 
	   
});





function setSuggTextArea(suggVal){
	suggSelectDialog.close();
	if(flagObj == "include") {
	    var incl=$("#include").val();
		$("#include").val(incl+suggVal);
	}else if(flagObj == "exclude") {
	    var exc=$("#exclude").val();
		$("#exclude").val(exc+suggVal);
	}
}
</script>