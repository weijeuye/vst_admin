<form id="dataForm">
        <table class="p_table form-inline">
                <input type="hidden" value="${isAdd!''}" id="isAdd"/>
            <tbody>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>出发地ID：</td>
                    <td>
                        <input type="text"   id="placeId"  name="placeId" maxlength="10" number="true" required=true value="${(channelFromPlace.placeId)!''}">
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>出发地编码：</td>
                    <td><input type="text" id="placeCode" name="placeCode"  maxlength="10" required=true value="${(channelFromPlace.placeCode)!''}">
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>出发地名称：</td>
                    <td>
                    	<input type="text"   id="placeName"  name="placeName"  maxlength="100" required=true value="${(channelFromPlace.placeName)!''}">
                    </td>
                </tr>
            </tbody>
        </table>
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="saveButton">保存</button>
<script>

$(function() {
    if ($("#isAdd").val() != "true") {
        $("#placeId").attr("readonly", "readonly");
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
            url = "/vst_admin/front/channelFromPlace/addChannelFromPlace.do";
        } else {
            url = "/vst_admin/front/channelFromPlace/updateChannelFromPlace.do";
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
                            addAndUpdateFromPlaceDialog.close();
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
