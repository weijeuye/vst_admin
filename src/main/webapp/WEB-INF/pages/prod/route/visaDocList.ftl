
<#include "/base/head_meta.ftl"/>
<div class="iframe_content mt10">
<form method="post"  id="dataForm"  >
    <table class="e_table form-inline" height="400">
			 <tr id="bizVisaDocList">
                 	<td width="150" class="e_label td_top"><i class="cc1">*</i>关联材料：</td>
                    <td><input type="hidden" id="docIds" name="docIds" value="${docIds!''}" class="w35">
                    	<input type="hidden" id="oldDocIds" name="oldDocIds" value="${docIds!''}" class="w35">
                    	<input type="hidden" id="productId" name="productId" value="${productId!''}" class="w35">
                    	<input type="hidden" id="lineRouteId" name="lineRouteId" value="${lineRouteId!''}" class="w35">
                    	<a class="btn btn_cc1" id="choice_material">选择（修改）材料</a>
                    	</br>已选材料：
                    	<table width="100%" border="1" cellpadding="1" cellspacing="0">
	                        <thead>
					        	<tr>
					            	<th>签证材料ID</th>
					                <th>签证材料名称</th>
					            	<th>签证国家/地区</th>
					                <th>签证类型</th>	                    
					                <th>送签城市</th>
					                <th>操作</th>
					            </tr>
					        </thead>
					        <tbody id="visaDoc">
					        <#if bizVisaDocList?? && bizVisaDocList?size gt 0>
					        	<#list bizVisaDocList as bizVisaDoc>
					        	<tr name='visadocTr' id="tr_${bizVisaDoc.docId!''}" data="${bizVisaDoc.docId!''}">
					        		<td>${bizVisaDoc.docId!''}</td>
					        		<td>${bizVisaDoc.docName!''}</td>
					        		<td>${bizVisaDoc.country!''}</td>
					        		<td> <#list vistTypeList as bizDict>
						                   <#if bizVisaDoc!=null && bizVisaDoc.visaType==bizDict.dictId>${bizDict.dictName}</#if>
									  	</#list>
									</td>
					        		<td><#list vistCityList as bizDict>
						                   <#if bizVisaDoc!=null && bizVisaDoc.city==bizDict.dictId>${bizDict.dictName}</#if>
									  	</#list>
									</td>
									<td>
										<a href='javascript:delVisaDoc(${bizVisaDoc.docId!''});'>删除</a>
									</td>
					        	</tr>
					        	</#list>
					        </#if>
	                        </tbody>
	            		</table>
            		</td>
                </tr>
            <tr>
               <td  ><a class="btn btn_cc1" id="save">保存</a> </td>
            </tr>
		</table>
	</form>
</div>
<script>
 var docVisaDialog; 
//选择签证材料
function onSelectDoc(params){
	if(params!=null){
		var docIds = $("#docIds").val();
		if (docIds.indexOf(params.docId) == -1) {
		 	if(docIds == ","){
		 		docIds = params.docId + ",";
		 	}else{
		 		docIds = docIds + params.docId + ",";
		 	}
		 	$("#docIds").val(docIds);
		}else{
			alert("已有该签证");
			return false;
		}
		var trID = "tr_"+params.docId;
		$("#visaDoc").append("<tr name='visadocTr' id="+trID+" data="+params.docId+"><td>"+params.docId+"</td><td>"+params.docName+"</td><td>"+params.docCountry+"</td><td>"+params.docVisaTypeName+"</td><td>"+params.docCity+"</td><td><a href='javascript:delVisaDoc("+params.docId+");'>删除</a></td></tr>");
	}
	docVisaDialog.close();
}


//打开选择签证材料窗口
$("#choice_material").click(function(){
	 var url = "/vst_admin/visa/visaDoc/selectBizVisaDocList.do";
     docVisaDialog = new xDialog(url,{},{title:"关联签证材料",iframe:true,width:"1000",height:"600"});
});

//移除该行签证材料
function delVisaDoc(docId){
	var tr = "#tr_"+docId;
	$(tr).remove();
	$("#docIds").val("");
	
	var docIds = ",";
	$('tr[name="visadocTr"]').each(function(){
		if(docIds == ","){
	 		docIds = $(this).attr("data") + ",";
	 	}else{
	 		docIds = docIds + $(this).attr("data") + ",";
	 	}
	 	$("#docIds").val(docIds);
	});
}

//保存签证
$("#save").click(function(){
 //  $("#dataForm").submit();
   var docIds = $("#docIds").val();
   if(docIds==''){
      alert("请选择签证材料");
      return false;
   }
    	$.ajax({
					url : "/vst_admin/prod/prodLineRoute/updateVisaDocRe.do",
					type : "post",
					dataType : 'json',
					data :  $("#dataForm").serialize(),
					success : function(result) {
					        if(result.code=="success"){
					          alert("设置成功");
		   				     
		   				      if(result.message=="true"){
		   				        $("#visaDocFlag",window.parent.document).val('true');
		   				      }
				            }else {
					           alert(result.message);
		   		            }
		   		     } 
				});
   
   
});
</script>