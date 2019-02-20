<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/connects/prod/playMethod/showSelectPlayMethod.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
            <input type="hidden" id="productId" value="${productId}" name="productId"/>
            <input type="hidden" id="categoryId" name="categoryId" value="${categoryId}"/>
           		<td class="s_label">选择类型:
	                <select name="playMethodTypeId">
	                   	<option value="">全部</option>
				    	<#list playMethodTypeList as playMethodType> 
				             <option value=${playMethodType.categoryId!''} <#if playMethodType.categoryId == playMethod.playMethodTypeId>selected</#if>>${playMethodType.categoryName!''}</option>
					    </#list>
				    </select>
                </td>
                <td class="s_label">玩法名称:
                    <input type="text" name="name" value="${(playMethod.name)!''}">
	                <a class="btn btn_cc1" id="search_button">查询</a>
                </td>
            </tr>
        </tbody>
    </table>	
	</form>
</div>

<div align="right">
	<input type="button" align="right" class="btn btn_cc1" id="make_sure" value="确定">	
	<input type="button" class="btn btn_cc1" id="cancel" value="取消">
</div>	
<!-- 主要内容显示区域 -->
<div class="iframe-content">   
   <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
	            <th>选择</th>
	            <th>玩法类型</th>
	        	<th>玩法名称</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as playMethod>
			<tr>
			<td>
				<input type="checkbox" value=${playMethod.playMethodId} name="playMethodId"/>
			</td>
			<td>
			    <#list playMethodTypeList as playMethodType>
					<#if playMethodType.categoryId == playMethod.playMethodTypeId>
					   <input type="hidden" value="${playMethodType.categoryId}"/>${playMethodType.categoryName!''}
					</#if>
				</#list>
			</td>
			<td>
			 ${playMethod.name!''}
            </td>
			</tr>
			</#list>
        </tbody>
    </table>
    <table class="co_table">
        <tbody>
          <tr>
            <td class="s_label">
               <#if pageParam.items?exists> 
				 <div class="paging" > 
					${pageParam.getPagination()}
				 </div> 
			   </#if>
            </td>
          </tr>
        </tbody>
    </table>

  </div><!--p_box-->	
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>

var productId = $("#productId").val();

//查询
$("#search_button").unbind("click");
$("#search_button").bind("click",function(){
	$("#searchForm").submit();
});

//点击确定事件
$("#make_sure").bind("click",function(){
   var checkboxArray = new Array();
   $("input[name='playMethodId']:checked").each(function(){    
      checkboxArray.push($(this).val());
   });  
    var stringArray=checkboxArray.join(','); 
    var str="";
   if(checkboxArray.length>1){
   		alert("只能选择一个玩法");
   		return;
   }
   if(checkboxArray.length==0){
     alert("请至少选择一种玩法！");
   }else{
	   $.ajax({
		  url : "/vst_admin/connects/prod/playMethod/saveSelectPlayMethod.do",
		  type : "post",
		  dataType:"JSON",
		  data : {"productId":productId,"stringArray":stringArray},
		  async:false,
		  success : function(result) {
		        $.alert("保存成功");
		        $("#showPlayMethodArray tbody", window.parent.document).empty();
                var str="";
                for(var i=0;i<result.length;i++){
                str += "<tr>" +
			      "<input type='hidden' value="+ result[i].playMethodId + "></input>"+
	              "<td>" + result[i].playMethodTpyeName + "</td>" +
	              "<td>" + result[i].name + "</td>" +
	              "<td>" + "<input type='text' onkeyup='javascript:RepNumber(this)' value="+ result[i].seq + "></input>" + "</td>" +
	              "<td>" +  "<a href='javascript:void(0);' class='btn btn_cc1' onclick='doDelete(" + productId + "," + result[i].playMethodId + ")'>删除</a>" + "</td>" +
	              "</tr>"
                }
                $("#havePlayMethod",window.parent.document).val("true");
                $("#showPlayMethodList",window.parent.document).show();
                parent.addtr(str);
                $("#save_button_div",window.parent.document).show();
				window.parent.selectMethodDialog.close();
		  }
	   });
   }
});

//取消
$("#cancel").bind("click",function(){
window.parent.selectMethodDialog.close();
});

</script>


