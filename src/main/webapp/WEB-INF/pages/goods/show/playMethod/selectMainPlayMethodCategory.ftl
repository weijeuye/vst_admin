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
	         <td class="s_label"  style="width:100px;">*选择主玩法品类</td>
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
                  <td>
                    <select id="playMethodType">
	                   	<option value="">请选择玩法类型</option>
				    	<#list playMethodTypeList as playMethodType> 
				             <option value=${playMethodType.categoryId!''} <#if playMethodType.categoryId == playMethodTypeId>selected</#if>>${playMethodType.categoryName!''}</option>
					    </#list>
				    </select>
                  </td>
                  <td>
                    <select id="playMethodName">
	                  <option value="">请设置主玩法品类</option>
				      <#if playMethodId?? && name??>
				       <#if allPlayMethodList?? &&  allPlayMethodList?size &gt; 0>
				         <#list allPlayMethodList as allPlayMethod>
				            <option value=${allPlayMethod.playMethodId!''} <#if allPlayMethod.playMethodId == playMethodId>selected</#if>>${allPlayMethod.name}</option>
				         </#list>
				       </#if> 
				      </#if>
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
		     if(value!="" && opts){
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
    if(cancelFlag == 'Y'){
        //产品有效 玩法类型，名称不可操作
	    $("#playMethodType").attr("disabled",true);
	    $("#otherPlayMethodCategory").show();
	} 
	if(cancelFlag == 'N'){
	   //产品无效
	   $("#playMethodType").attr("disabled",false);
	   if(playMethodTypeId != ""){
	     $("#playMethodName").attr("disabled",false);
	   }
	   if(playMethodName != ""){
	     $("#otherPlayMethodCategory").show();
	   }
	}
	if($("#showPlayMethodArray tbody tr").size()>0){
	   $("#save_button_div").show();
	}
});
   var selectOptionVal = $("#playMethodName option:selected").val();
   var playMethodTypeIdOne  = $("#playMethodType option:selected").val();
$("#playMethodType").change(function(){
       //拿到被选中的产品类型，根据选中的产品类型来自动显示玩法品类
       var changePlayMethodTypeId  = $("#playMethodType option:selected").val();
       if(playMethodTypeIdOne != ""){
	       if(changePlayMethodTypeId == ""){
	            var opts = document.getElementById("playMethodName");
		            for(var i=0;i<opts.options.length;i++){
	                     if("" == opts.options[i].value){
	                         opts.options[i].selected = 'selected';
	                         break;
	                      }
	                }
	            $("#playMethodName").attr("disabled",true);
	       }else if(changePlayMethodTypeId == playMethodTypeIdOne){
			    var opts = document.getElementById("playMethodName");
		        if(changePlayMethodTypeId!=""){
		            for(var i=0;i<opts.options.length;i++){
	                     if(selectOptionVal == opts.options[i].value){
	                         opts.options[i].selected = 'selected';
	                         break;
	                     }
	                }
	            }
	            $("#playMethodName").attr("disabled",false);
		   }
		}else{
		   	var playMethodTypeId  = $("#playMethodType option:selected").val();
		    //清空，重新查询
			$("#playMethodName").empty();
		    $("#playMethodName").append('<option value="">请设置主玩法品类</option>');
			var str="";      
			$.ajax({
			url : '/vst_admin/show/playMethod/ajaxRequest.do',
			type : "post",
		    dataType:"JSON",
		    data : {"playMethodTypeId":playMethodTypeId},
			async:true,
			success : function(data) {
				$.each(data,function(key,values){
					<#--key:玩法Id，value：玩法名称-->
				    str += "<option value=" +key + ">"+values+"</option>";
			    });
				$("#playMethodName").append(str);
		    }
	        });
		    $("#playMethodName").attr("disabled",false);
		}
});
var cancelFlag = $("#cancelFlag").val();   
//当用户有选中玩法名称时，显示其他玩法品类
$("#playMethodName").change(function(){
       var mainPlayMethodCategoryId = $("#playMethodName option:selected").val();
	   if(mainPlayMethodCategoryId != ""){
	     //如果有选择玩法品类，就显示其他玩法品类
	     $("#otherPlayMethodCategory").show();
	     if(cancelFlag == 'N'){
	   	    $("#save_button_div").show();
	     }
	   }else{
	     $("#otherPlayMethodCategory").hide();
	   }
}); 

var selectMethodDialog;
var productId = $("#productId").val();
//添加其他玩法
function newButton(){
 var playMethodId = $("#playMethodName option:selected").val();
   var url = "/vst_admin/show/playMethod/showSelectPlayMethod.do?productId="+productId+"&playMethodId="+playMethodId;
   selectMethodDialog =  new xDialog(url,{}, {title:"选择其他玩法",iframe:true,height:"550",width:800});
}
//删除按钮
function doDelete(productId,playMethodId){
    	 $.confirm('确认要删除玩法吗？',function(){
		 $.ajax({
			url:'/vst_admin/show/playMethod/deletePlayMethod.do',
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
	var sign = "N";
    $.ajax({
		url : "/vst_admin/show/playMethod/selectProdProduct.do",
		type : "post",
		dataType:"JSON",
		data : {"productId":productId},
		async:false,
		success : function(result) {
				$("#showPlayMethodArray tbody tr").each(function(){
			        var seq=$(this).find('td').eq(2).find('input').first().val();
			        var getPlayMethodId = $(this).find('input').eq(0).val();
				    var  tableValue = {'seq':seq,'playMethodId':getPlayMethodId}
				    tableValueArray.push(tableValue);
			    });
				if("Y" != result.cancelFlag){
					//无效产品
					$.ajax({
							 url : "/vst_admin/show/playMethod/selectMainPlayMethod.do",
							 type : "post",
							 dataType:"JSON",
							 data : {"productId":productId},
							 async:false,
							 success : function(result) {
							        if(null != result){
							           //主玩法有变化
							           if(playMethodId != result.playMethodId){
							           		checkMainPlayMethod(tableValueArray,playMethodId,sign);
							           }else{
							                saveFunction(productId,playMethodId,tableValueArray,sign);
							           }
							        }else{
							             //由空  变为 有
							            if(playMethodId.length != 0){
							            	checkMainPlayMethod(tableValueArray,playMethodId,sign);
							            }else{
							            	saveFunction(productId,playMethodId,tableValueArray,sign);
							            }
							        }	
							 }
					});		
				}else{
					//有效产品
					//发ajax，查询现在的主玩法
					$.ajax({
							 url : "/vst_admin/show/playMethod/selectMainPlayMethod.do",
							 type : "post",
							 dataType:"JSON",
							 data : {"productId":productId},
							 async:false,
							 success : function(result) {
								 if(result != null){
								 	if(playMethodId != result.playMethodId){
					                    //主玩法有变化
									    $.confirm('有效产品的主玩法不能更改,确定只保存次玩法吗',function(){
										    sign = "N"; 
											if(null != result.playMethodId){
											   saveFunction(productId,result.playMethodId,tableValueArray,sign);	
											}												
									    });
									}else{
										//主玩法无变化	
										if(null != result.playMethodId){
											saveFunction(productId,result.playMethodId,tableValueArray,sign);	
										}
									}
								 }else{
								 	updateFunction(productId,tableValueArray,sign);
								 }
							 }
					});
				}	
		}
	});
}

function checkMainPlayMethod(tableValueArray,playMethodId,sign){
	//更改了主玩法
		$.each(tableValueArray,function(i){
			var str = JSON.stringify(tableValueArray[i]);
			var playMethodIdList = eval('('+str+')').playMethodId;
			if(playMethodId == playMethodIdList){
			    sign = "Y";
				//用户选择的玩法在列表中已经存在
				$.confirm('该玩法已经存在，是否删除与此相同的次玩法？',function(){
					$.ajax({
						url:'/vst_admin/show/playMethod/deletePlayMethod.do',
						type:'post',
						data : {"playMethodId":playMethodIdList,"productId":productId,"sign":sign},
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
								saveFunction(productId,playMethodId,tableValueArray,sign);
						},
						error:function(result){
							  alert(result.message);
						}
					});
				});
			}
		})
		if("Y" != sign){
		    saveFunction(productId,playMethodId,tableValueArray,sign);
		}
}

//保存函数
function saveFunction(productId,playMethodId,tableValueArray,sign){
	$.ajax({
		url : "/vst_admin/show/playMethod/saveAllPlayMethod.do",
		type : "post",
		dataType:"JSON",
		data : {"productId":productId,"playMethodId":playMethodId,"tableValueArray":JSON.stringify(tableValueArray),"sign":sign},
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

//保存次玩法更改的
function updateFunction(productId,tableValueArray,sign){
	$.ajax({
		url : "/vst_admin/show/playMethod/saveAllPlayMethod.do",
		type : "post",
		dataType:"JSON",
		data : {"productId":productId,"tableValueArray":JSON.stringify(tableValueArray),"sign":sign},
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