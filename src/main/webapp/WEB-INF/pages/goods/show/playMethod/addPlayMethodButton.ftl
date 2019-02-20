<!DOCTYPE html>
<html>
<head>
  <#include "/base/head_meta.ftl"/>
  <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
</head>
<body>
<div class="iframe_content">
<#if error??>
    <div align="center" style="padding-top:100px;">
	    <font size='5px' color="red">${error!''}</font><br/><br/>
	    <a href="javascript:void(0);" class="btn btn_cc1" id="return_button" onclick="javascript:history.go(-1)">返回</a>
	 </div>
<#else>
     <div class="p_box box_info">
	        <table class="s_table" style="margin-top: 10px;">
	            <tbody>
	                <tr>
	                	<td class="s_label"  style="width:100px;">
	                	  <a href="javascript:void(0);" class="btn btn_cc1" id="new_button" data=${productId}>添加玩法</a>
	                	</td>
	                </tr>
	            </tbody>
	        </table>
	</div>
  <#if playMethodList?? && playMethodList?size &gt; 0>	
  <!-- 主要内容显示区域\\ -->
    <div class="p_box box_info">
    	<table class="p_table table_center" style="margin-top: 10px;">
            <thead>
                <tr>
                	<th width="40px">产品ID</th>
                    <th width="80px">所属上级</th>
                    <th width="100px">玩法名称</th>
                    <th width="30px">SEQ</th>
                    <th width="80px">操作</th>
                </tr>
            </thead>
            <tbody>
	            <#list playMethodList as playMethod>
				    <tr>
						<td>${productId}</td>
						<td>
						  <#list subCategoryList as subCategory>
						    <#if subCategory.categoryId == playMethod.subCategoryId>
							  ${subCategory.categoryName!''}
						    </#if>
					      </#list>
						</td>
						<td>${playMethod.name!''}</td>
						<td>
						 <input value="${playMethod.seq!''}" type="text" onkeyup="javascript:RepNumber(this)" name="seq"/>
						</td>
						<td class="oper">
						   <a class="btn btn_cc1 delete" data="${playMethod.playMethodId}"  id="delete_button">删除</a>
						</td>
				    </tr>
			    </#list>
	         </tbody>
        </table>
	</div><!-- div p_box -->
  <!-- //主要内容显示区域 -->
  <#else>
	<div class="hint mb10">
		<span class="icon icon-big icon-info"></span>抱歉，您尚未添加玩法！
	</div>
  </#if>
</#if>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>

<script>

   var productId = $("#new_button").attr("data");

//添加玩法
var addMethodDialog;
$("#new_button").unbind("click");
$("#new_button").bind("click",function(){
	var url = "/vst_admin/ticket/playMethod/showSelectPlayMethod.do?productId="+productId;
	addMethodDialog =  new xDialog(url,{}, {title:"选择玩法",iframe:true,height:"550",width:800});
});

//删除玩法
$('.delete ').bind("click",function(){
     var playMethodId = $(this).attr('data');
     
 		 $.confirm('确认要删除玩法吗？',function(){
		 $.ajax({
			url:'/vst_admin/ticket/playMethod/deletePlayMethod.do',
			type:'post',
			data : {"playMethodId":playMethodId,"productId":productId},
			success:function(result){
				if(result.code=='success'){
				 	$.alert(result.message,function(){
				 	window.location.reload();
			        });
				}else{
					$.alert(result.message);			 	 	 
				}					
			}
		});													 
	});
});

//$("#return_button").bind("click",function(){
// window.location.reload();
//});

//限制seq只能为数字
function RepNumber(obj) {
var reg = /^[\d]+$/g;
if (!reg.test(obj.value)) {
var txt = obj.value;
txt.replace(/[^0-9]+/, function (char, index, val) {//匹配第一次非数字字符
obj.value = val.replace(/\D/g, "");//将非数字字符替换成""
var rtextRange = null;
if (obj.setSelectionRange) {
obj.setSelectionRange(index, index);
} else {//支持ie
rtextRange = obj.createTextRange();
rtextRange.moveStart('character', index);
rtextRange.collapse(true);
rtextRange.select();
}
})
}
}
</script>


