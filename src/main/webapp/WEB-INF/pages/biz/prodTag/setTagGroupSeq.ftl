<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<style>
.tb{
  margin-left:15px;
}
th {
  width:200px;
  height:34px;
  text-align:center;
}
td {
  width:200px;
  height:25px;
  text-align:center;
}
</style>
     <div>
     	<a class='btn JS_copy_btn_ok' style='margin-top: 10px; margin-left: 577px;'>新增</a>
       <table class="tb" border=1 style="margin-top:10px;">
          <thead bgcolor="#87CEFA">
            <tr>
              <th>小组名</th>
              <th>当前SEQ值</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
          <#if tagGroups?size gt 0>
          <#assign index=0>
          <#list tagGroups as bizTag>
            <tr>
              <td>
              	<input type="text" id="groupName_${index}" readonly = "readonly" style="border-style:none;width:200px;height:25px;text-align:center" value="${bizTag.tagGroupName}" />
              	<input type="hidden" id="groupId_${index}" value="${bizTag.tagGroupId}"/>
              </td>
              <td>
              	<input type="text" class ="setSeq" id="seq_${index}" readonly = "readonly" style="border-style:none;width:200px;height:25px;text-align:center" value="${bizTag.seq}"/>
              </td>
              <td>
              	<a href="javascript:void(0);" class="editBizTagGroup" data="${bizTag.tagGroupId!''}" data2="${bizTag.tagGroupName!''}" data3="${bizTag.seq!''}">修改</a>
		        <a href="javascript:void(0);" class="removeBizTagGroup" data="${bizTag.tagGroupId!''}">删除</a>
		        <a href="javascript:void(0);" class="showLogDialog" param="parentId=${bizTag.tagGroupId}&parentType=TAG_GROUP&sysName=VST">操作日志</a>
              </td>
              <#assign index = index+1>
            </tr>
          </#list>
          </#if>
          </tbody>
       </table>
   	 </div>
   	 
   	 <div id="tagGroupDialog" style="display: none;">
	  <p>
	  	<form id="tagGroupForm">
	    <table class="p_table form-inline" width="100%">
	        <tboby>
	            <tr>
	             <td>
	               <label for="tagGroupName"><i class="cc1">*</i>小组名称：</label>
	             </td>
	             <td>  
				   <input type="text"  id="tagGroupName" name="tagGroupName" maxlength="15" required=true/>  
				   <input type="hidden" name="tagGroupId" id="tagGroupId"/> 
				 </td>
	            </tr>
	            <tr>
	              <td>
	               <label for="seq"><i class="cc1">*</i>新SEQ值:</label>
	              </td>
	              <td>    
				    <input type="text"  id="seq" name="seq" required=true />
				  </td>
	            </tr>
	        </tboby>
	    </table>
	    </form>
	  </p>
	</div>
	
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
$(function() {

	var tagGroupDialog;
	
	/**
	 * 验证整数或验证非零的负整数
	*/
	jQuery.validator.addMethod("isPositive", function(value, element) {
	
		if(value > 9999) {
			alert('排序值不能大于 10000');
			return false;
		}
		
		var chars =  /^[1-9]\d*$/;// 验证正整数  
		return this.optional(element) || chars.test(value);       
	}, "只能填写整数");	
    
    jQuery.validator.addMethod("isNameNotExisted", function(value, element) {
		
		var ele =  $(element);
		var currentTagGroupId = ele.parent().find('#tagGroupId').val();
		for(var i = 0; i < ${index}; i++) {
			var groupNameId = 'groupName_' + i;
			var groupId = 'groupId_' + i;
			var tagGroupName = $("#" + groupNameId).val();
			var tagGroupId = $("#" + groupId).val();
			if(currentTagGroupId != tagGroupId && $.trim(value) == $.trim(tagGroupName) ) {
				return false;
			}
		
		}
		return true;     
    }, "此名字已经存在！");	
    
 	
 	$("a.JS_copy_btn_ok").click(function() {
 	
 		clearFormData();
   		tagGroupDialog = pandora.dialog ({
	 		title : "新增小组",
	 		dialogAutoTop: 300,
	 		content:$('#tagGroupDialog'),
       		width: 350,
       		modal: true,
       		okValue: "确定",
            ok: function() {
            	if(!$("#tagGroupForm").validate ({
					rules : {
						tagGroupName: {
							required : true,
							isNameNotExisted : true
						},
						seq: {
							required : true,
							isPositive : true 
						}				
					}
				}).form()) {
					return false;
				}; 
				
            	$.post("/vst_admin/biz/bizTag/saveOrUpdateTagGroup.do", $("#tagGroupForm").serialize(),
               	  function (data) {
                  	if (data.code == "success") {            
                    	alert(data.message);
                        refresh();
                        tagGroupDialog.close();                               
                     } else {
                        alert(data.message);
                        return;
                     }
                    }
                );
            }
        });
	});
	
	
	$("a.editBizTagGroup").click(function() {
	
   		clearFormData();
   		var tagId = $(this).attr("data");
		var tagGroupName = $(this).attr("data2");
		var seq = $(this).attr("data3");
		
		$("#tagGroupDialog, form, #tagGroupId").val(tagId);
		$("#tagGroupDialog, form, #tagGroupName").val(tagGroupName);
		$("#tagGroupDialog, form, #seq").val(seq);
   		
   		tagGroupDialog = pandora.dialog ({
	 		title : "修改小组",
	 		dialogAutoTop: 300,
	 		content:$('#tagGroupDialog'),
       		width: 350,
       		modal: true,
       		okValue: "确定",
            ok: function() {
            	
            	if(!$("#tagGroupForm").validate ({
					rules : {
						tagGroupName: {
							required : true,
							isNameNotExisted : true
						},
						seq: {
							required : true,
							isPositive : true 
						}				
					}
				}).form()) {
					return false;
				}; 
               	
               	$.post("/vst_admin/biz/bizTag/saveOrUpdateTagGroup.do", $("#tagGroupForm").serialize(),
               	  function (data) {
                  	if (data.code == "success") {            
                    	alert(data.message);
                        refresh();
                        tagGroupDialog.close();                               
                     } else {
                        alert(data.message);
                        return;
                     }
                   }
                );
            }
        });
	});
	
	
	$("a.removeBizTagGroup").click(function() {
   			
   		var tagGroupId =  $(this).attr("data");
   		pandora.confirm('是否删除小组？只有小组下无标签才能被删除', function(data) {
   		
   				$.ajax({
        			url : "/vst_admin/biz/bizTag/deleteTagGroup.do",
        			type : "post",
        			data: {"tagGroupId" : tagGroupId},
        			success : function(result) {
        					if (result.code == "success") {            
                				alert(result.message);
                    			refresh();                                 
                			 } else {
                     			alert(result.message);
                 			 }
        				 }
        			
        		});	
		});
	});
	
	
	$("a.showLogDialog").click(function() {
   		
   		var tagGroupId =  $(this).data("id");
	});
});

function clearFormData() {

	$('#tagGroupDialog, form, #tagGroupName').val('');
	$('#tagGroupDialog, form, #tagGroupId').val('');
	$('#tagGroupDialog, form, #seq').val('');
}


function refresh() {
	
	location.reload();
}

</script>