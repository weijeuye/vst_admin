<form id="dataForm">
        <table class="p_table form-inline">
            <tbody> 
              <input type="hidden" value="${isAdd!''}" id="isAdd"/>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>站点编码：</td>
                    <td>
                        <input type="text"   id="areaCode" maxlength="30" number="true"  name="areaCode" required=true value="${(channelArea.areaCode)!''}">
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>站点名称：</td>
                    <td><input type="text" id="areaName"   maxlength="50" name="areaName" required=true value="${(channelArea.areaName)!''}">
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>站点类型:</td>        
                	<td> 
                	  <select name="areaType" required=true>
	                   	<option value="">请选择</option>
				    	<#list areaTypeList as areaType> 
				           <option value="${(areaType.code)!''}" <#if (channelArea.areaType)?? && areaType.code == channelArea.areaType>selected</#if>>${(areaType.cnName)!''}</option>
					    </#list>
				    </select>
				    </td>
                </tr>
            </tbody>
        </table>
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="saveButton">保存</button>
<script>
$(function() {
    if ($("#isAdd").val() != "true") {
        $("#areaCode").attr("readonly", "readonly");
    }
});

$("#saveButton").on("click", function() {
      trimInput();
    if (!$("#dataForm").validate().form()) {
        return;
    }
    var msg = '确认保存吗 ？';
    $.confirm(msg, function() {
        //遮罩层
        $("#saveButton").attr("disabled", "disabled");
        var url = "";
        if ($("#isAdd").val() == "true") {
            url = "/vst_admin/front/channelArea/addChannelArea.do";
        } else {
            url = "/vst_admin/front/channelArea/updateChannelArea.do";
        }
        $.ajax({
            url: url,
            type: "post",
            dataType: 'json',
            data: $("#dataForm").serialize(),
            success: function(result) {
                if (result.code == "success") {
                    pandora.dialog({
                        wrapClass: "dialog-mini",
                        content: result.message,
                        okValue: "确定",
                        mask: true,
                        ok: function() {
                            $("#saveButton").removeAttr("disabled");
                            addAndUpdateChannelAreaDialog.close();
                            $("#searchForm").submit();
                        }
                    });
                } else {
                    $.alert(result.message);
                    $("#saveButton").removeAttr("disabled");
                }
            },
            error: function() {
                $("#saveButton").removeAttr("disabled");
            }
        });
    });

});
</script>
