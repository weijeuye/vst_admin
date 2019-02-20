<#include "/base/foot.ftl"/>
<div class="iframe_search">
<form id="dataForm">
<input type="hidden" id="groupId" name="groupId" value="${group.groupId!''}">
<input type="hidden" id="suggId" name="suggId" value="${group.suggId!''}">
    <table class="p_table form-inline">
        <tbody>
             <tr>
				<td class="p_label"><span class="notnull">*</span>名称：</td>
                <td>
                	<input id="groupName" name="groupName" type="text" required=true maxlength="50" value="${group.groupName!''}">
                </td>
            </tr>
            <tr>
				<td class="p_label"><span class="notnull">*</span>副标题：</td>
                <td>
                	<input id="groupTitle" name="groupTitle" type="text" required=true maxlength="100" value="${group.groupTitle!''}">
                </td>
            </tr>
            <tr>
            	<td class="p_label"><span class="notnull">*</span>排序值：</td>
                <td><input id="seq" name="seq" required=true maxlengh="50"  value="${group.seq!''}"></td>
            </tr>
            <tr>
            	<td class="p_label"><span class="notnull">*</span>该分类中的描述内容为：</td>
                <td>
                	<input type="radio" name="selectType" <#if group.selectType==1>checked</#if> value="1"  required=true>&nbsp;单选
            		<input type="radio" name="selectType" <#if group.selectType==2>checked</#if> value="2"  required=true>&nbsp;复选
                </td>
            </tr>
            <!--
            <tr>
            	<td class="p_label"><span class="notnull">*</span>是否允许维护时新增描述内容：</td>
            	<td>
                	<input type="radio" name="addFlag" <#if group.addFlag=='Y'>checked</#if> value="Y">&nbsp;是
            		<input type="radio" name="addFlag" <#if group.addFlag=='N'>checked</#if> value="N">&nbsp;否
                </td>
            </tr>
            -->
        </tbody>
    </table>
    <button class="pbtn pbtn-small btn-ok" style="float:middle;margin-top:20px;" id="addButton">确认并保存</button>
    <button class="pbtn pbtn-small btn-ok" style="float:middle;margin-top:20px;" id="cancelButton">取消</button>
</form>
</div>
<script>
$("#cancelButton").bind("click",function(){
	if ($("#groupId").val()=="")
		addGroupDialog.close();
	else
		updateGroupDialog.close();
});

$("#addButton").bind("click",function(){
	if($("#seq").val()<0){
        alert("排序值只能是大于或等于0的数值");
        return false;
    }
	$(this).attr("disabled","disabled");

	//验证
	if (!$("#dataForm").validate({
		rules : {	
			seq : {
				isNum : true
			}
		},
		messages : {
			seq : '只能输入数字'
		}
	}).form()) {
		$(this).removeAttr("disabled");
		return false;
	}

		//遮罩层
		var loading = pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/biz/suggestionGroup/addOrModifyGroup.do",
			type : "post",
			dataType : 'json',
			async: false,
			data : $("#dataForm").serialize(),
			success : function(result) {
				$("#addButton").removeAttr("disabled");
				loading.close();
				if (result.code == "success") {
					if ($("#groupId").val()=="") {
						addGroupDialog.close();
					} else {
						updateGroupDialog.close();
						groupListDialog.reload();
						//window.location = "/vst_admin/biz/suggestionGroup/findGroupList.do?suggId="+$("#suggId").val();
					}
				} else {
					$.alert(result.message);
				}
			},
			error : function() {
				$("#addButton").removeAttr("disabled");
				loading.close();
				addGroupDialog.close();
			}
		});
	});
</script>
