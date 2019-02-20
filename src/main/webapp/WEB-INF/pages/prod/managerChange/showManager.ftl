
<div class="form-group">
    <input type="hidden" id="type" name="type" value="${type!''}" />
    <label>
        <span class="w90 inline-block text-right">交接产品经理</span>

        <div class="inline-block">
            <input class="search form-control w90" type="text" id="newManagerName" name="newManagerName"value="">
            <input type="hidden" id="newManagerId" name="newManagerId" value="">
        </div>
    </label>
    <div style="width: 100%; height: 100%; margin-top: 20px; margin-left: 20px;">
        <span class="btn-group">
            <a class="btn btn-primary" id="confrim">确定</a>
        </span>
        <span class="btn-group" style="margin-left: 30px;">
            <a class="btn btn-primary" id="closeDialog">取消</a>
        </span>
    </div>
</div>

<script>
    vst_pet_util.superUserSuggest("#newManagerName","#newManagerId");

    $("#confrim").click(function () {
        var newManagerName=$("#newManagerName").val();
        var newManagerId=$("#newManagerId").val();
        changeManager(newManagerName, newManagerId, $("#type").val());
    });
    $("#closeDialog").click(function () {
        changeManagerDialog.close();
    });
</script>

