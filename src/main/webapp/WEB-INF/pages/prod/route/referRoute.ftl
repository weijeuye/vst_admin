<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
    <div>
    <input type="hidden" id="productId" value="${productId!''}"/>
    <input type="hidden" id="categoryId" value="${categoryId!''}"/>
    <input type="hidden" id="lineRouteId" value="${lineRouteId!''}"/>
    <input type="hidden" id="subCategoryId" value="${subCategoryId!''}"/>
    <input type="hidden" id="modelVersion" value="${modelVersion!''}"/>
    <input type="hidden" id="productType" value="${productType!''}"/>
    </div>
    <div>
         说明：
    </div>
    <div>
    1、请输入需要引用行程的产品ID
    </div>
    <div>
    2、若引用的产品为多行程，请选择具体引用的行程对象
    </div>
   	<div style='margin-top:10px; margin-left:10px;'>
   	<span>产 	品	ID：
   	<input type='text' value='' id='referProductId' maxlength='11'/>
   	</span>
   	</div>
   	<div style='margin-top:30px; margin-left:10px;'>
   	<span>行程名称：
   	<select id="routename">
   	</select>
   	</span>
   	</div>
   	<a class='btn JS_copy_btn_ok' style='margin-top:30px; margin-left:70px;'>确定</a>
   	<a class='btn JS_copy_btn_cancel' style='margin-top:30px; margin-left:80px;'>取消</a>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
$("#referProductId").bind("blur",function(){
   $("#routename").empty();
   var parten = /^[0-9]*$/;
   if(!parten.test($("#referProductId").val())){
      $.alert("请输入正确的id");
   }
   var productId = $("#referProductId").val();
   if(productId != ""){
      $.ajax({
       url:"/vst_admin/prod/prodLineRoute/getProdLineRouteList.do",
       type : "post",
	   dataType : 'json',
	   data :  'productId='+productId,
	   success : function(result){
	         if(result.code=="success"){
	             var msg = result.message;
	             var data = eval(msg);
	             $.each(data,function(n,value){
	                $("#routename").append("<option value='" + value.routeId + "'>"+ value.routeName+ "</option>");
	             });
	         }else{
	             $.alert(result.message);
	         }
	   }
   });
   }
});

$("a.JS_copy_btn_ok").click(function(){
   var referProductId = $("#referProductId").val();
   var referRouteId = $("#routename").find("option:selected").attr("value");
   var mainRouteId = $("#lineRouteId").val();
   var msg = "引用新的行程后，原有行程明细内容以及关联内容将被删除，请确认";
   if(referRouteId == 'undefined' || referRouteId == null || referRouteId == ""){
      $.alert("引用行程不能为空");
      return;
   }
   if(productId != "" && referRouteId != ""&& mainRouteId != ""){
    $.confirm(msg, function(){
      $.ajax({
       url:"/vst_admin/prod/prodLineRoute/referProductRoute.do",
       type : "post",
	   dataType : 'json',
	   data :  'referProductId=' + referProductId + '&mainRouteId='+ mainRouteId+ '&referRouteId=' + referRouteId,
	   success : function(result){
	   	
	             parent.confirmAndRefresh(result);
	   }
     });
    });
   }
});

$("a.JS_copy_btn_cancel").click(function(){
   parent.closeDialog(); 
});
</script>