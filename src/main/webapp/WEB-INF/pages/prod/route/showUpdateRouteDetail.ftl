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
       <li><a href="#">${prodProduct.bizCategory.categoryName!''}</a> &gt;</li>
        <li><a href="#">${packageType!''}</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">行程</li>
    </ul>
</div> 

<div class="iframe_content mt15">
	<span style="font-weight:bold;font-size:15px;">行程展示：${prodLineRoute.routeName}</span>
	<a style="font-size:13px;margin-left:10px;" href="/vst_admin/prod/prodLineRoute/showUpdateRoute.do?productId=${prodProduct.productId}">返回行程</a>
</div>

<form action="/vst_admin/packageTour/prod/product/addProdLineRouteDetail.do" method="post" id="dataForm">
		<input type="hidden" name="lineRouteId" value="${prodLineRoute.lineRouteId}" />
		<input class="w35" type="hidden" required="true" name="productId" id="productId" value="${RequestParameters["productId"]}">
		<#if prodProduct??>
			<input  class="w35" type="hidden" name="packageType" id="packageType" value="${prodProduct.packageType!''}"/>
		</#if>
		<input type="hidden" name="senisitiveFlag" value="N">
       <div class="p_box box_info p_line">
            <div class="box_content">
	           	<table id="editTable">
		           	<#if prodLineRouteDetailList ?? &&prodLineRouteDetailList?size gt 0 >
						<#list prodLineRouteDetailList as r>
							<tr>
								<td > 
									 <table style="margin-top: 5px;" class="e_table form-inline">
									<tr>
							        	<td class="e_label"><span class="notnull">*</span>
							        		第 <span name="nDay">${r_index+1}</span> 天 ：
							        		<input type="hidden" class="nDay" name="prodLineRouteDetailList[${r_index}].nDay" value="${(r.nDay??)?string(r.nDay,r_index+1)}">
							        	</td>
							            <td>
							            	<label><input type="text" class="w35 title" style="width:700px" name="prodLineRouteDetailList[${r_index}].title"  value="${r.title}" required=true maxlength="250">&nbsp;</label>
							            </td>
							        </tr>
									<tr>
							        	<td class="e_label"><span class="notnull">*</span>行   程：</td>
							            <td>
							            	<label> 
							            		<textarea maxlength="2000" class="content"  required=true  name="prodLineRouteDetailList[${r_index}].content" rows="10" style="width:700px;color:#060606;cursor:auto" >${r.content}</textarea>
							            	</label> 
							            	<div id="productNameError"></div>
							            </td>
							        </tr>
							       	<tr>
										<td class="e_label">住   宿：</td>
										<td> 
											<#if r.stayType??>
												<input type="radio" checked="checked" value="yes" class="zhusu" name="zhusu[${r.detailId}]"/>含住宿
												<input type="radio" value="no" class="zhusu" name="zhusu[${r.detailId}]"/>不含住宿				
												<select class="stayType" name="prodLineRouteDetailList[${r_index}].stayType">
								                    <#list hotelStarList as hotel>
								                		<option value='${hotel.dictId}' ${(hotel.dictId == r.stayType )?string('selected=\"selected\"','')}>${hotel.dictName}</option>
									                </#list>
								                </select>
								                <input class="stayDesc" maxlength="250" name="prodLineRouteDetailList[${r_index}].stayDesc" value="${r.stayDesc}" type="text" > 注，文本框里面可输入具体酒店等内容
											<#else>
												<input type="radio" value="yes" class="zhusu" name="zhusu[${r.detailId}]"/>含住宿
												<input type="radio" checked="checked" class="zhusu" value="no" name="zhusu[${r.detailId}]"/>不含住宿						
												<select class="stayType" disabled="disabled"  name="prodLineRouteDetailList[${r_index}].stayType">
								                    <#list hotelStarList as hotel>
								                		<option value='${hotel.dictId}' ${(hotel.dictId == r.stayType )?string('selected=\"selected\"','')}>${hotel.dictName}</option>
									                </#list>
								                </select>
								                <input class="stayDesc" disabled="disabled" maxlength="250" name="prodLineRouteDetailList[${r_index}].stayDesc" value="${r.stayDesc}" type="text" > 注，文本框里面可输入具体酒店等内容
											</#if>
										</td>
							        </tr>
							       	<tr>
										<td class="e_label">用   餐：</td>
										<td>
											 <input type="checkbox" ${(r.breakfastFlag =='Y')?string('checked=\"checked\"','')} class="breakfastFlag" value="Y" name="prodLineRouteDetailList[${r_index}].breakfastFlag"/>
											  早餐<input type="text" <#if r.breakfastFlag!='Y'>disabled="disabled"</#if> class="breakfastDesc"  value="${r.breakfastDesc}" maxlength="250" name="prodLineRouteDetailList[${r_index}].breakfastDesc"> &nbsp;
											  
											  <input type="checkbox" ${(r.lunchFlag =='Y')?string('checked=\"checked\"','')}  class="lunchFlag"  value="Y" name="prodLineRouteDetailList[${r_index}].lunchFlag"/>
											  中餐<input <#if r.lunchFlag!='Y'>disabled="disabled"</#if> type="text"  class="lunchDesc"  value="${r.lunchDesc}" maxlength="250"  name="prodLineRouteDetailList[${r_index}].lunchDesc"> &nbsp;
											  
											  <input type="checkbox" ${(r.dinnerFlag =='Y')?string('checked=\"checked\"','')}  class="dinnerFlag"  value="Y" name="prodLineRouteDetailList[${r_index}].dinnerFlag"/>
											  晚餐<input <#if r.dinnerFlag!='Y'>disabled="disabled"</#if> type="text"  class="dinnerDesc"  value="${r.dinnerDesc}" maxlength="250" name="prodLineRouteDetailList[${r_index}].dinnerDesc"> &nbsp;
							           	</td>
							        </tr>
							       	<tr>
										<td class="e_label">交   通：</td>
										<td>
							                <!-- 选中飞机时，勾选第一个飞机 -->
											<#if r.trafficType??&&r.trafficType?contains("AIRCRAFT")>
						                    	<input type="hidden" name="aircraft_${r_index}" value="AIRCRAFT">
						                    </#if>
											<!-- 选中汽车时，勾选巴士 -->
											<#if r.trafficType??&&r.trafficType?contains("CAR")>
				                         		<input type="hidden" name="car_${r_index}" value="CAR">
				                          	</#if>
				                          	
											<#list trafficList as t>
												 <input class="trafficType" ${(r.trafficType??&&r.trafficType?index_of(t.code)!=-1)?string('checked=\"checked\"','')}  type="checkbox" name="prodLineRouteDetailList[${r_index}].trafficType"  value='${t.code}'/>${t.cnName}&nbsp;
							                </#list>
							                <#if r.trafficType=='OTHERS'>
							                	<input type="text" maxlength="250" class="trafficOther"  value="${r.trafficOther}"  name="prodLineRouteDetailList[${r_index}].trafficOther"  >	
											<#else>
												<input type="text" disabled="disabled" maxlength="250" class="trafficOther"  value="${r.trafficOther}"  name="prodLineRouteDetailList[${r_index}].trafficOther"  >
							                </#if>
							           	</td>
							        </tr>
							       	<tr style="border-bottom: dashed 1px #D9D9D9 ; ">
							       		<td class="e_label"> </td>
										<td  style="float:right;">
											 <input type="button" onclick="delTr2($(this))" data1="${r.routeId}" data="${r.detailId}" name='delBtn'	value="删除">
											 <input type="button" onclick="addTr2('editTable', -7)" value="插入一天">
							           	</td>
							        </tr> 
							        </table>
								</td>
							</tr>
			       		</#list>
		       		<#else> 
		       			 <#include "/prod/route/showUpdateRouteDetailTable.ftl" >
		       		</#if>
	           	</table>
            </div>
        </div>
        <#if embedFlag !="Y">
        <div class="p_box box_info clearfix mb20" >
            <div class="fl operate" >
            	<a class="btn btn_cc1" id="save">保存</a>
            	<a class="btn btn_cc1" id="saveAndNext">保存并下一步</a>
            <!--	<a href="javascript:void(0);" class="btn btn_cc1 showLogDialog" param="{'objectId':${RequestParameters["productId"]},'objectType':'PROD_LINE_ROUTE_DETAIL'}">查看操作日志</a> -->
            </div>
        </div>
        </#if>
</form>

<div id="tbData" style="display:none;">
	<#include "/prod/route/showUpdateRouteDetailTable.ftl" >
</div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	//处理交通类型
	$("input[type='hidden'][name^='aircraft_']").each(function(index, domEle){
		$(domEle).parent().find("input[value='PLANE']").attr("checked","checked");
	});
	
	$("input[type='hidden'][name^='car_']").each(function(index, domEle){
		$(domEle).parent().find("input[value='BARS']").attr("checked","checked");
	});
	
 	// 住宿
	 $("input[type=radio][class=zhusu]").live("click",function(){
	 	if($(this).attr('checked')=='checked'){
			var value = $(this).val();
		    var data = $(this).attr("data");
		 	if(value=='yes'){
		 	  	$(this).next().next().removeAttr('disabled');
		 	  	$(this).next().next().next().removeAttr('disabled');
		 	}else{
		 	  	$(this).next().attr('disabled','disabled');
		 	  	$(this).next().next().attr('disabled','disabled');	 	  	
		 	}	 		
	 	}
	 }); 
	 
	// 早餐
	 $("input[type=checkbox][class=breakfastFlag]").live("click",function(){
	 	if($(this).attr('checked')){
	 	  	$(this).next().removeAttr('disabled');
	 	}else{
	 		$(this).next().attr('disabled','disabled');
	 	}
	 }); 
	 
	// 中餐
	 $("input[type=checkbox][class=lunchFlag]").live("click",function(){
	 	if($(this).attr('checked')){
	 	  	$(this).next().removeAttr('disabled');
	 	}else{
	 		$(this).next().attr('disabled','disabled');
	 	}
	 }); 
	 
	// 晚餐
	 $("input[type=checkbox][class=dinnerFlag]").live("click",function(){
	 	if($(this).attr('checked')){
	 	  	$(this).next().removeAttr('disabled');
	 	}else{
	 		$(this).next().attr('disabled','disabled');
	 	}
	 }); 	
	 
	// 交通-其他
	 $("input[type=checkbox][class=trafficType]").live("click",function(){
	 	var obj = $(this);
	 	if(obj.val()=='OTHERS'){
			if($(this).attr('checked')){
		 	  	$(this).next().removeAttr('disabled');
		 	}else{
		 		$(this).next().attr('disabled','disabled');
		 	}	 	
	 	}
	 });

	$("#save").on('click', function(event){
		trySubmit();
	});
	window.trySubmit = function() {
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
				url : "/vst_admin/packageTour/prod/product/addProdLineRouteDetail.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						  $("#saveRouteFlag",window.parent.document).val('true');
						  $("#route",parent.document).parent("li").trigger("click");
						  
						  //lineRouteId, productId, productType
						  if(window.parent && window.parent.kickoffCostEdit) {
								window.parent.kickoffCostEdit(${prodLineRoute.lineRouteId}, ${prodProduct.productId}, "${prodProduct.productType}");
						  }	
					}});
				},
				error : function(result) {
					loading.close();
					$.alert(result.message);
				}
			});
		});	
	}
	
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
				url : "/vst_admin/packageTour/prod/product/addProdLineRouteDetail.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						$("#saveRouteFlag",window.parent.document).val('true');
						var packageType = $("#packageType").val();
						if(packageType != null &&  packageType.length > 0){
							if(packageType == 'LVMAMA'){
								$("#supplier",parent.document).remove();
								$("#lvmama",parent.document).show();		
								$("#saveRouteFlag",window.parent.document).val('true');					
								$("#route",parent.document).parent("li").trigger("click");
							}else if(packageType == 'SUPPLIER'){
								$("#lvmama",parent.document).remove();
								$("#supplier",parent.document).show();	
								$("#saveRouteFlag",window.parent.document).val('true');						
								$("#route",parent.document).parent("li").trigger("click");
							}
						}
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
	var detailId = o.attr('data');
	var routeId = o.attr('data1');
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
				url : "/vst_admin/packageTour/prod/product/deleteProdLineRouteDetail.do",
				type : "post",
				dataType : 'json',
				data : {detailId:detailId,routeId:routeId,productId:productId},
				success : function(result) {
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						$("#saveRouteFlag",window.parent.document).val('true');
						window.location.href = '/vst_admin/prod/prodLineRoute/editprodroutedetail.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}'
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
				url : "/vst_admin/packageTour/prod/product/deleteProdLineRouteDetail.do",
				type : "post",
				dataType : 'json',
				data : {detailId:detailId,routeId:routeId,productId:productId},
				success : function(result) {
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						$("#saveRouteFlag",window.parent.document).val('true');
						window.location.href = '/vst_admin/prod/prodLineRoute/editprodroutedetail.do?lineRouteId=${prodLineRoute.lineRouteId}&productId=${prodProduct.productId}'
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
   		var nDaySpans=$("span[name='nDay']");
   		//alert("nDaySpans: "+nDaySpans);
   		$.each(nDaySpans,function(n,o) {  
          //  alert(n+', '+o.innerHTML);  
        	o.innerHTML=n+1;
        }); 
        
        var fieldArr=new Array("nDay","title","content","stayType","stayDesc","breakfastFlag","lunchFlag","dinnerFlag","breakfastDesc","lunchDesc","dinnerDesc","trafficOther");
        for(var i=0;i<fieldArr.length;i++)
        {
        	//alert(i+": "+fieldArr[i]);
           resetName($("."+fieldArr[i]),fieldArr[i]); 
        }
        
        //"trafficType"  重名字的checkbox不能直接自增
        resetNameForCheckbox($(".trafficType"),"trafficType",${trafficList?size}); 
       
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
     	  o.name="prodLineRouteDetailList["+i+"]."+nameValue;
        }); 
    }
        
   //重置name
   function resetName(arr,nameValue)
   {
 	  	$.each(arr,function(n,o) {  
           o.name="prodLineRouteDetailList["+n+"]."+nameValue;
           if(nameValue=="nDay")
           {
           		o.value=n+1;
           }
        }); 
   } 
	
	refreshSensitiveWord($("input[type='text'],textarea"));
</script>