<style>
    input{
        width:30px;
    }
</style>
<div>
    <form id="limitForm">
        <input type="hidden" name="reserveLimitId" value="${bizReserveLimit.reserveLimitId}"/>
        <input type="hidden" name="reserveType" value="${bizReserveLimit.reserveType}"/>
        <table class="p_table form-inline">
            <tbody>
            <tr>
                <td width="60px;">*限制类型</td>
                <td>
                    <select readonly="true" disabled style="width: 110px">
                        <option>${bizReserveLimit.reserveName}</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>*运营类别</td>
                <td>
                    <select readonly="true" disabled style="width: 110px">
                        <option>
                        <#if bizReserveLimit.operationCategory == 'LONGGROUP'>
                            长线
                        <#elseif bizReserveLimit.operationCategory == 'SHORTGROUP'>
                            短线
                        </#if>
                        </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>*预订限制</td>
                <td height="100px">
                ${bizReserveLimit.reserveContent}
                </td>
            </tr>
            <tr>
                <td>&nbsp;目的地</td>
                <td>${bizReserveLimit.destNameStr}</td>
            </tr>
            </tbody>
        </table>
    </form>
    <div>
        <button class="pbtn-small btn-ok" style="float:right;margin-top:20px;" id="saveBtn">保存</button>
        <button class="pbtn-small btn-ok" style="float:right;margin-top:20px;margin-right:20px;" id="cancelBtn">取消</button>
    </div>
</div>
<script>
    $("#cancelBtn").bind("click", function(){
        $(".dialog-close").trigger("click");
    });

    $("#saveBtn").bind("click", function() {
        var dataFlag = 'Y', reg = /^[0-9]\d*$/;
        $(".ageLimit").each(function(){
            if(!reg.test($(this).val())){
                dataFlag = 'N';
                return;
            }
        });
        if(dataFlag == 'N'){
            $.alert("请输入合法数字");
            return;
        }
        data = $(this).parent().siblings("#limitForm").serialize();
        $.ajax({
            url:"/vst_admin/biz/reserveLimit/saveReserveLimit.do",
            type:"post",
            dataType:"json",
            data:data,
            success:function(result){
                if(result.code == 'success'){
                    $.alert(result.message,function(){
                        dialog.close();
                        window.location.reload();
                    });
                }else{
                    $.alert(result.message);
                }
            },
            error:function(){
                $.alert("请求失败");
            }
        });
    });
</script>