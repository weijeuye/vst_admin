<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
    <div> <input type="hidden" value="${objectId}" id="objectId" name="objectId"> </div>
    <div>
    <span style='margin-top:60px; margin-left:40px;'>提示：引用成功后将填充或覆盖原产品图片特色 </span>
    </div>
   	<div style='margin-top:60px; margin-left:40px;'>
   	<span>产 	品	ID：
   	<input type='text' value='' id='quoteProductId' maxlength='11'/>
   	</span>
   	</div>
   	<a class='btn JS_copy_btn_ok' style='margin-top:30px; margin-left:70px;'>确定</a>
   	<a class='btn JS_copy_btn_cancel' id="dialog" style='margin-top:30px; margin-left:80px;'>取消</a>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>

$("a.JS_copy_btn_ok").click(function(){
   var msg = "引用新的产品图片特色后，原有产品图片特色被删除，请确认";
   //被引用产品id
   var quoteProductId = $("#quoteProductId").val();
   //原产品id
   var productId = $("#objectId").val();
   if(quoteProductId == productId){
      alert("不能输入当前产品！");
      return;
   }
   var parten = /^[0-9]*$/;
   if(quoteProductId == "" || !parten.test(quoteProductId)){
      alert("请输入正确的产品id。");
   }else{
      $.ajax({
	       url : "/vst_admin/pub/comphoto/isQuoteProductId.do?quoteProductId="+quoteProductId+"&objectId="+productId,
	       type:"POST",
	       dataType:"JSON",
	       success : function(result){
	          if(result.code=="error"){
	              alert("此产品没有图片可覆盖，不进行覆盖操作")
	          }else{
	              $.confirm(msg, function(){
                      window.parent.location.href = "/vst_admin/pub/comphoto/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=PRODUCT_ID&logType=PROD_PRODUCT_PRODUCT_CHANGE&imgLimitType=LIMIT_3_2_3L";
                  });
	          }
	       }
	  });
   }
});

$("a.JS_copy_btn_cancel").click(function(){
     parent.closeDialog();
});
</script>