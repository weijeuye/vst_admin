<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_content">
    <div class="p_box box_info">
	    <table class="s_table" style="margin-top: 10px;">
	       <tr>
	         <td class="s_label"  style="width:100px;">*主玩法</td>
	       </tr>
	    </table>
	</div>
    <!-- 选择区域开始\\ -->
    <div class="p_box box_info">
    	<table class="p_table table_center" style="margin-top: 10px;">
            <thead>
                <tr>
                	<th width="300px">玩法类型</th>
                    <th width="300px">玩法名称</th>
                    <th width="300px">SEQ</th>
                    <th width="300px">操作</th>
                </tr>
            </thead>
            <tbody>
               <tr>
                 <input type="hidden" id="productId" value="${productId}"/>
                 <input type="hidden" id="cancelFlag" value="${cancelFlag}"/>
                 <input type="hidden" id="categoryId" value="${categoryId}"/>
                  <td>
                    <select id="playMethodType">
				    	<#list playMethodTypeList as playMethodType> 
				             <option  readonly="readonly" value=${playMethodType.categoryId!''} <#if playMethodType.categoryId == playMethodTypeId>selected</#if>>${playMethodType.categoryName!''}</option>
					    </#list>
				    </select>
                  </td>
                  <td>
                    <select id="playMethodName">
				        <option   readonly="readonly" selected>${(mainPlayMethod.name)!''}</option>
				    </select>
                  </td>
                  <td>0</td>
                  <td>不可操作</td>
                </tr>
            </tbody>
        </table>
	</div><!-- div p_box -->
    <!-- //选择区域结束 -->
    <div class="p_box box_info" id="otherPlayMethodCategory">
        <table class="s_table" style="margin-top: 10px;">
	       <tr>
	         <td style="width:150px;text-align:center;">其他玩法名称</td>
             <td style="width:1500px;text-align:right;">
                 <a href='javascript:void(0);' class='btn btn_cc1' onclick='newButton()'>添加其他玩法</a>
             </td>
	       </tr>
	    </table>
	</div>
    <!-- 显示玩法列表开始 -->
    <div class="p_box box_info" id="showPlayMethodList">
    	<table class="p_table table_center" style="margin-top: 10px;" id="showPlayMethodArray">
            <thead>
                <tr>
                	<th width="300px">玩法类型</th>
                    <th width="300px">玩法名称</th>
                    <th width="300px">SEQ</th>
                    <th width="300px">操作</th>
                </tr>
            </thead>
            <tbody>
             <#if playMethodList?? &&  playMethodList?size &gt; 0>
              <#list playMethodList as playMethod>
               <tr>
               <input type='hidden' value=${playMethod.playMethodId}>
               <td>${playMethod.playMethodTpyeName}</td>
               <td>${playMethod.name}</td>
               <td><input type='text' value=${playMethod.seq}></input></td>
               <td><a href='javascript:void(0);' class='btn btn_cc1' onclick='doDelete(${productId},${playMethod.playMethodId})'>删除</a></td>
               </tr> 
               </#list>  
              </#if>           
            </tbody>
          </table>
          <div align="center" style="padding-top:10px;" id="save_button_div">
             <a href='javascript:void(0);' class='btn btn_cc1' onclick='saveButton()'>保存</a>
          </div>
	</div>
	<!-- 显示玩法列表结束-->
</div>
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
$(document).ready(function(){
    var cancelFlag = $("#cancelFlag").val();
    var playMethodTypeId  = $("#playMethodType option:selected").val();
    var playMethodName  = $("#playMethodName option:selected").val();
    $("#otherPlayMethodCategory").hide();
    $("#save_button_div").hide();
	if(playMethodTypeId != ""){
	     var opts = document.getElementById("playMethodName");
	     var value = $("#playMethodName option:selected").val();
		     if(value!=""){
		          for(var i=0;i<opts.options.length;i++){
	                  if(value==opts.options[i].value){
	                      opts.options[i].selected = 'selected';
	                      break;
	                  }
	              }
	         }
	}
    //未选择产品类型情况下，禁止选择玩法品类
	$("#playMethodName").attr("disabled",true);
     //产品有效 玩法类型，名称不可操作
	$("#playMethodType").attr("disabled",true);
	$("#otherPlayMethodCategory").show();
	if($("#showPlayMethodArray tbody tr").size()>0){
	   $("#save_button_div").show();
	}
});

var selectMethodDialog;
var productId = $("#productId").val();
//添加其他玩法
function newButton(){
    var url = "/vst_admin/connects/prod/playMethod/showSelectPlayMethod.do?productId="+productId;
    var categoryId=$("#categoryId").val();
    if(categoryId){
   		 url+="&categoryId="+categoryId;
     }
   selectMethodDialog =  new xDialog(url,{}, {title:"选择其他玩法",iframe:true,height:"550",width:800});
}
//删除按钮
function doDelete(productId,playMethodId){
    	 $.confirm('确认要删除玩法吗？',function(){
		 $.ajax({
			url:'/vst_admin/connects/prod/playMethod/deletePlayMethod.do',
			type:'post',
			data : {"playMethodId":playMethodId,"productId":productId},
			success:function(result){
					$("#showPlayMethodArray tbody").empty();
		            var i;
			        $.each(result,function(i){ 
				      $("#showPlayMethodArray tbody").append(
				      "<tr>" +
				      "<input type='hidden' value="+ result[i].playMethodId + "></input>"+
		              "<td>" + result[i].playMethodTpyeName + "</td>" +
		              "<td>" + result[i].name + "</td>" +
		              "<td>" + "<input type='text' onkeyup='javascript:RepNumber(this)' value="+ result[i].seq + "></input>" + "</td>" +
		              "<td>" +  "<a href='javascript:void(0);' class='btn btn_cc1' onclick='doDelete(" + productId + "," + result[i].playMethodId + ")'>删除</a>" + "</td>" +
		              "</tr>" );
	                });			
			},
			error:function(result){
			      alert(result.message);
			}
		});													 
	});
}

function saveButton(){
  	var playMethodId = $("#playMethodName option:selected").val();
    var tableValueArray=[];
	//主玩法与列表中的次玩法是否有重复  标志
	  $("#showPlayMethodArray tbody tr").each(function(){
			        var seq=$(this).find('td').eq(2).find('input').first().val();
			        var getPlayMethodId = $(this).find('input').eq(0).val();
				    var  tableValue = {'seq':seq,'playMethodId':getPlayMethodId}
				    tableValueArray.push(tableValue);
     });	
	saveFunction(productId,tableValueArray);
}

//保存函数
function saveFunction(productId,tableValueArray){
	$.ajax({
		url : "/vst_admin/connects/prod/playMethod/saveAllPlayMethod.do",
		type : "post",
		dataType:"JSON",
		data : {"productId":productId,"tableValueArray":JSON.stringify(tableValueArray)},
		async:false,
		success : function(result) {
			if(result.code=="success"){
			    $.alert("保存成功！");
			}else {
				$.alert(result.message);
			}
		}
	});
}

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
})}
}

function addtr(str){
	$("#showPlayMethodArray tbody").append(str);
}

</script>