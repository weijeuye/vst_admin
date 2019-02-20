<form id="dataForm">
        <table class="p_table form-inline">
            <input type="hidden" value="${isAdd!''}" id="isAdd"/>
            <tbody>
                <input type="hidden" value="${(channelAreaFrom.configId)!''}" name="configId" />
                <tr>
                	<td class="p_label"><i class="cc1">*</i>频道：
                	</td>
                    <td><input type="text" id="channelPage" name="channelPage" required=true value="${(channelAreaFrom.channelPage)!''}" maxlength="15">
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>站点：
                	</td>
                    <td>
                    	<input type="text"   id="areaName"  name="channelArea.areaName" required=true value="${(channelAreaFrom.channelArea.areaName)!''}">
                    	<input type="hidden" id="areaCode"  name="areaCode" required=true value="${(channelAreaFrom.areaCode)!''}">
                    </td>
                </tr>
                <tr>
                    <td class="p_label"><i class="cc1">*</i>出发地：</td>
                    <td>
                    	<input type="text" id="placeName" name="placeName"  required=true value="${(channelAreaFrom.fromPlace.placeName)!''}">
                        <input type="hidden" id="placeId" name="placeId" value="${(channelAreaFrom.placeId)!''}">
                    </td>
                </tr>
                 <tr>
                    <td class="p_label">父级出发地：</td>
                    <td>
                    	<input type="text" id="parentPlaceName" name="parentPlaceName" value="${(channelAreaFrom.parentFromPlace.placeName)!''}">
                        <input type="hidden" id="parentPlaceId" name="parentPlaceId" value="${(channelAreaFrom.parentPlaceId)!''}">
                    </td>
                </tr>
                <tr>
                    <td class="p_label">焦点图配置：</td>
                    <td>
                    	<input type="text" id="focusPlaceCode" name="focusPlaceCode"
                        value="${(channelAreaFrom.focusPlaceCode)!''}" maxlength="10">
                    </td>
                </tr>
				<tr>
				   <td class="p_label"><i class="cc1">*</i>有效性：</td>
                    <td>
                    	<select name="valid" id="valid" required=true>
                    	<option value="">请选择</option>
                         <option <#if (channelAreaFrom.valid)?? && channelAreaFrom.valid == "Y">selected="selected"</#if> value="Y">有效</option>
                        <option <#if (channelAreaFrom.valid)?? && channelAreaFrom.valid == "N">selected="selected"</#if> value="N">无效</option>
                    	</select>
                    </td>
                </tr>
            </tbody>
        </table>
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="saveButton">保存</button>
<script>
var selectChannelAreaDialog;
var selectChannelFromPlaceDialog;
$(function() {
    if ($("#isAdd").val() != "false") {
        //选择站点
        $("#areaName").on("focus", function() {
            var url = "/vst_admin/front/channelArea/findChanleAreaList.do?queryType=select";
            selectChannelAreaDialog = new xDialog(url, {}, {
                title: "选择站点",
                iframe: true,
                width: 800,
                height: 500
            });
        });
    } else {
        $("#channelPage").attr("readonly", "readonly");
        $("#areaName").attr("readonly", "readonly");
    } 



});

$("#saveButton").on("click", function() {
    var msg = '确认保存吗 ？';
    trimInput();
    if (!$("#dataForm").validate().form()) {
        return;
    }
    var url = "";
    if ($("#isAdd").val() == "true") {
        url = "/vst_admin/front/channelAreaFrom/addChannelAreaFrom.do";
    } else {
        url = "/vst_admin/front/channelAreaFrom/updateChannelAreaFrom.do"
    }
    $.confirm(msg, function() {
        //遮罩层
        $("#saveButton").attr("disabled", "disabled");
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
                            addAndUpdateDialog.close();
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



$("#placeName").on("focus", function() {
    var url = "/vst_admin/front/channelFromPlace/findChannelFromPlaceList.do?queryType=select&parent=false";
    selectChannelFromPlaceDialog = new xDialog(url, {}, {
        title: "选择出发地",
        iframe: true,
        width: 800,
        height: 500
    });
});

$("#parentPlaceName").on("focus", function() {
    var url = "/vst_admin/front/channelFromPlace/findChannelFromPlaceList.do?queryType=select&parent=true";
    selectChannelFromPlaceDialog = new xDialog(url, {}, {
        title: "选择父级出发地",
        iframe: true,
        width: 800,
        height: 500
    });
});
</script>
