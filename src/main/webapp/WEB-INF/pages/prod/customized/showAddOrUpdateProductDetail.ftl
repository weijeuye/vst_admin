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
        <li class="active">产品详情</li>
    </ul>
</div> 

<form action="/vst_admin/prod/customized/addCustomizedProdDetail.do" method="post" id="dataForm">
		<input class="w35" type="hidden" required="true" name="productId" id="productId" value="${RequestParameters["productId"]}">
		<input type="hidden" name="senisitiveFlag" value="N">
       <div class="p_box box_info p_line">
            <div class="box_content">
	           	<table id="editTable">
		           	<#if customizedProdDetailList ?? &&customizedProdDetailList?size gt 0 >
						<#list customizedProdDetailList as r>
							<tr>
								<td > 
									 <table style="margin-top: 5px;" class="e_table form-inline">
									<tr>
							        	<td class="e_label"><span class="notnull">*</span>
							        		详情模块 <span name="seq">${r_index+1}</span> ：标题：
							        		<input type="hidden" class="seq" name="customizedProdDetailList[${r_index}].seq" value="${(r.seq??)?string(r.seq,r_index+1)}">
							        	</td>
							            <td>
							            	<label><input type="text" class="w35 title customizedProdDetailName" style="width:700px" name="customizedProdDetailList[${r_index}].customizedProdDetailName"  value="${r.customizedProdDetailName}" required=true maxlength="250">&nbsp;</label>
							            </td>
							        </tr>
									<tr>
							        	<td class="e_label"><span class="notnull">*</span>描   述：</td>
							            <td>
							            	<label> 
							            		<textarea maxlength="2000" class="description"  required=true  name="customizedProdDetailList[${r_index}].description" rows="10" style="width:700px" >${r.description}</textarea>
							            	</label> 
							            	<div id="productNameError"></div>
							            </td>
							        </tr>
							       	<tr style="border-bottom: dashed 1px #D9D9D9 ; ">
							       		<td class="e_label"> </td>
										<td  style="float:right;">
											 <input type="button" onclick="delTr2($(this))" data1="${r.customizedProdDetailId}"  name='delBtn'	 value="删除">
											 <input type="button" onclick="addTr2('editTable', -4)" value="插入一天">
							           	</td>
							        </tr> 
							        </table>
								</td>
							</tr>
			       		</#list>
		       		<#else> 
		       			 <#include "/prod/customized/showAddProductDetail.ftl" >
		       		</#if>
	           	</table>
            </div>
        </div>
         
        <div class="p_box box_info clearfix mb20" >
            <div class="fl operate" >
            	<a class="btn btn_cc1" id="save">保存</a>
            	<a class="btn btn_cc1" id="saveAndNext">保存并下一步</a>
            <!--	<a href="javascript:void(0);" class="btn btn_cc1 showLogDialog" param="{'objectId':${RequestParameters["productId"]},'objectType':'PROD_LINE_ROUTE_DETAIL'}">查看操作日志</a> -->
            </div>
        </div>
</form>

<div id="tbData" style="display:none;">
	<#include "/prod/customized/showAddProductDetail.ftl" >
</div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	$("#save").bind("click",function(){
		//验证
	   if(!$("#dataForm").validate().form()){
			return false;
	   }
	   
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
				url : "/vst_admin/prod/customizedProdDetail/addCustomizedProdDetail.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						  $("#saveRouteFlag",window.parent.document).val('true');
						  $("#productDetail",parent.document).parent("li").trigger("click");
						 // $("#productSubject",parent.document).parent("li").trigger("click");
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
		//验证
		 if(!$("#dataForm").validate().form()){
			return false;
		 }

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
				url : "/vst_admin/prod/customizedProdDetail/addCustomizedProdDetail.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						$("#saveRouteFlag",window.parent.document).val('true');
								$("#saveRouteFlag",window.parent.document).val('true');					
								$("#route",parent.document).parent("li").trigger("click");
					}});
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
		});	
	});
	
	//如果是查看模式，则取消掉点击事件
	if($("#isView",parent.document).val()=='Y'){
		$("#save,#saveAndNext").remove();
	}
	
  ////////添加一行、删除一行封装方法///////
  /**
   * 为table指定行添加一行
   *
   * tab 表id
   * row 行数，如：0->第一行 1->第二行 -2->倒数第二行 -1->最后一行
   * trHtml 添加行的html代码
   *
   */
  function addTr(tab, row, trHtml){
     //获取table最后一行 $("#tab tr:last")
     //获取table第一行 $("#tab tr").eq(0)
     //获取table倒数第二行 $("#tab tr").eq(-2)
     //var table0=$("#"+tab);
     var $tr=$("#"+tab+" tr").eq(row);
     //alert("table0: "+table0.html());
     //alert("$tr: "+$tr.html());
     if($tr.size()==0){
        alert("指定的table id或行数不存在！");
        return;
     }
     $tr.after(trHtml);
  }
   
  function delTr2(o){
  	var obj=o.parent().parent().parent().parent().parent().parent();
    var delBtnArr=$("input[name='delBtn']");
	var customizedProdDetailId = o.attr('data1');
	//var routeId = o.attr('data1');
    var categoryId = $('#categoryId',window.parent.document).val();
    var productId = $('#productId',window.parent.document).val();
    if(!(categoryId==17 || categoryId==18 || categoryId==16)){
 	    var ids = 0;
 	    $("input[name='delBtn']").each(function(){
			 var dId = $(this).attr('data');
			 if(dId>0){
			 	ids=ids+1;
			 }
 	    });
	    if(ids>1)
	    {	
		    if(!confirm("确定删除？"))
		    {
		    	return ;
		    }
			$.ajax({
				url : "/vst_admin/prod/customizedProdDetail/deleteCustomizedProdDetail.do",
				type : "post",
				dataType : 'json',
				data : {customizedProdDetailId:customizedProdDetailId,productId:productId},
				success : function(result) {
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						$("#saveRouteFlag",window.parent.document).val('true');
						
					}});
				},
				error : function(result) {
					$.alert(result.message);
				}
			});		    
	    }else{
	 		if(delBtnArr.length<=2)
		    {
		    	alert("剩下的最后一行不能删除,如果需要删除此行，请先添加一行");
		    	return ;			       	
		    }else{		
			    if(!confirm("确定删除？"))
			    {
			    	return ;
			    }		    
				obj.remove();
				resetSeq();
			}		    	
	    }
    }else{
		if(detailId>0){
		    if(!confirm("确定删除？"))
		    {
		    	return ;
		    }	
			$.ajax({
				url : "/vst_admin/prod/customizedProdDetail/deleteCustomizedProdDetail.do",
				type : "post",
				dataType : 'json',
				data : {customizedProdDetailId:customizedProdDetailId,productId:productId},
				success : function(result) {
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						$("#saveRouteFlag",window.parent.document).val('true');
					}});
				},
				error : function(result) {
					$.alert(result.message);
				}
			});		
		}else{
		    if(delBtnArr.length<=2)
		    {
			    if(confirm("数据不存在，确认清空？"))
			    {
			    	$("#route",parent.document).parent("li").trigger("click");
			    	return ;
			    }	    	
		    }else{		
			    if(!confirm("确定删除？"))
			    {
			    	return ;
			    }		    
				obj.remove();
				resetSeq();
			}		
		}
	}
  }
   
  /**
   * 全选
   * 
   * allCkb 全选复选框的id
   * items 复选框的name
   */
  function allCheck(allCkb, items){
   $("#"+allCkb).click(function(){
      $('[name='+items+']:checkbox').attr("checked", this.checked );
   });
  }
  
  var globalIndex = 0;
 
  function addTr2(tab, row){
	var tbData=document.getElementById("tbData");
	var textHtml = tbData.innerHTML;
	textHtml = textHtml.replace(/{index}/g,globalIndex);
	var trHtml="<tr><td>"+textHtml+"</td></tr>";
    addTr(tab, row, trHtml);
    resetSeq();
    globalIndex++;
  }
   
   //重建与序列有关的所有元素
   function resetSeq()
   {
   		//天数
   		var nDaySpans=$("span[name='seq']");
   		//alert("nDaySpans: "+nDaySpans);
   		$.each(nDaySpans,function(n,o) {  
          //  alert(n+', '+o.innerHTML);  
        	o.innerHTML=n+1;
        }); 
        
        var fieldArr=new Array("seq","customizedProdDetailName","description");
        for(var i=0;i<fieldArr.length;i++)
        {
        	//alert(i+": "+fieldArr[i]);
           resetName($("."+fieldArr[i]),fieldArr[i]); 
        }
        
   }
   
	//size表示每隔多少个自增   	
    function resetNameForCheckbox(arr,nameValue,size)
    {
    	var i=-1;
	  	$.each(arr,function(n,o) {  
	  	  if(n%size==0)
	  	  {
	  	  	 i++;	
	  	  }	
     	  o.name="customizedProdDetailList["+i+"]."+nameValue;
        }); 
    }
        
   //重置name
   function resetName(arr,nameValue)
   {
 	  	$.each(arr,function(n,o) {  
           o.name="customizedProdDetailList["+n+"]."+nameValue;
           if(nameValue=="seq")
           {
           		o.value=n+1;
           }
        }); 
   } 
	
	refreshSensitiveWord($("input[type='text'],textarea"));
</script>