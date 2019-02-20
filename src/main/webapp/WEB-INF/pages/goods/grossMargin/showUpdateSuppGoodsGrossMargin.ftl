<form action="/vst_admin/goods/goods/updateSuppGoods.do" method="post" id="dataForm" class="goodsForm" style="overflow-y: auto;height:500px;">
    <input type="hidden" name="suppGoodsGrossMarginId" value="${suppGoodsGrossMargin.suppGoodsGrossMarginId}">
    <table class="p_table form-inline">
        <tbody>
        <tr>
            <td class="p_label"><i class="cc1">*</i>品类：</td>
            <td colspan=2>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="1"  required /><span>酒店</span></label>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="11" required /><span>景点门票</span></label>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="12" required /><span>其他票</span></label>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="13" required /><span>组合套餐票</span></label>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="15" required /><span>跟团游</span></label><br/>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="18" required /><span>自由行</span></label>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="16" required /><span>当地游</span></label>
                <label class="checkbox"><input type="checkbox" name="categoryIds" value="17" required /><span>酒店套餐</span></label>
            </td>
        </tr>
        <tr>
            <td class="p_label"><i class="cc1">*</i>所属分公司：</td>
            <td colspan=2>
                <select name="filiale" required>
				<#list filialeList as list>
                    <option value=${list.code!''} <#if suppGoodsGrossMargin.filiale ==list.code >selected=selected</#if> >${list.cnName!''}</option>
				</#list>
                </select>
            </td>
        </tr>
        <tr>
            <td class="p_label"><i class="cc1">*</i>所属BU：</td>
            <td colspan=2>
                <select name="bu" required>
				<#list buList as list>
                    <option value=${list.code!''} <#if suppGoodsGrossMargin.bu ==list.code >selected=selected</#if>  >${list.cnName!''}</option>
				</#list>
                </select>
            </td>
        </tr>

        <tr>
            <td class="p_label"><i class="cc1">*</i>毛利基准：</td>
            <td colspan=2>
                <input type="radio" name="grossMarginType" value="FIXED" <#if suppGoodsGrossMargin.grossMarginType =="FIXED" >checked=checked</#if>  >固定金额
                <input type="radio" name="grossMarginType" value="PERCENT" <#if suppGoodsGrossMargin.grossMarginType =="PERCENT" >checked=checked</#if> >百分比
                <input type="text" name="grossMarginName" id="grossMarginName" style="margin-left:20px;width:50px;margin-right:5px;" value="${suppGoodsGrossMargin.grossMargin/100}">元/%
                <input type="hidden" name="grossMargin" id="grossMargin">
            </td>
        </tr>
        <tr>
            <td class="p_label"><i class="cc1">*</i>通知接收人：</td>
            <td colspan=2>
                <table id="receiverTable">
                    <tr>
                        <td colspan="2"><input type="text" id="receiver"></td>
                    </tr>
                    <tr><td id="2392"><input type="hidden" name="grossMarginReceiverList[0].userId" value="2392">王小松</td><td></td></tr>
                    <tr><td id="1108"><input type="hidden" name="grossMarginReceiverList[1].userId" value="1108">曾俊</td><td></td></tr>
                    <tr><td id="4138"><input type="hidden" name="grossMarginReceiverList[2].userId" value="4138">庞瑶</td><td></td></tr>
                    <tr><td id="4156"><input type="hidden" name="grossMarginReceiverList[3].userId" value="4156">卞慧俊</td><td></td></tr>
                    <#assign index = 4/>
                    <#list suppGoodsGrossMargin.grossMarginReceiverList as receiver>
                        <#if receiver.userId!=2392 && receiver.userId!=1108 && receiver.userId!=4138 && receiver.userId!=4156>
                        <tr><td id="${receiver.userId}"><input type="hidden" name="grossMarginReceiverList[${index}].userId" value="${receiver.userId}">${receiver.userName}</td><td><a class="delReceiver">删除</a></td>
                            <#assign index=index+1 />
                        </#if>
                    </#list>
                    </td>
                    </tr>
                </table>
        </tbody>
    </table>
</form>
<div class="p_box box_info clearfix mb20">
    <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc1" id="save">保存</a></div>
</div>
<script>
    var reciverIndex = ${suppGoodsGrossMargin.grossMarginReceiverList?size};
    vst_pet_util.superUserSuggestAdvance("#receiver",function(item){
        if(item.id!="" && $("#receiverTable").find("#"+item.id).size() == 0){
            var tr = '<tr><td id='+item.id+'><input type="hidden" name="grossMarginReceiverList['+reciverIndex+'].userId" value="'+item.id+'">'+item.text+'</td><td><a class="delReceiver">删除</a></td></tr>';
            $("#receiverTable").append(tr);
            reciverIndex++;
        }
        $("#receiver").val("");
    });
</script>

<script>


    var categoryIds = "${suppGoodsGrossMargin.categoryId}";
    if(categoryIds!=null){
       var ids =  categoryIds.split(",");
        for(var i=0;i<ids.length;i++){
            $("input[name=categoryIds][value="+ids[i]+"]").attr("checked","checked");
        }
    }



    $("#save").bind("click",function(){
        var formValidate =  $("#dataForm").validate();
        formValidate.resetForm();
        $("#grossMarginName").rules("add",{required : true, number : true,isNum:true , min : 0,messages : {min:'价格必须大于等于0',isNum:'价格格式不正确(填至多2位小数正数)'}});

        //验证
        if(!formValidate.form()){
            return false;
        }
        $("#save").hide();
        var msg = '是否保存!';
        $.confirm(msg,function(){
            $("#grossMargin").val(parseInt($("#grossMarginName").val()*100));
            $.ajax({
                url : "/vst_admin/goods/grossMargin/updateSuppGoodsGrossMargin.do",
                type : "post",
                data : $(".dialog #dataForm").serialize(),
                success : function(result) {
                    $("#save").show();
                    confirmAndRefresh(result);
                },
                error : function(){
                    $("#save").show();
                }
            })
        },function(){
            $("#save").show();
        });
    });

    var destSelectDialog;
    var index = ${suppGoodsGrossMargin.grossMarginReceiverList?size}+1;
    //选择
    function onSelectDest(destArray){
        if(destArray!=null && destArray.length > 0){
            for(var i=0;i<destArray.length;i++){
                var obj = destArray[i];
                if($("#attributionTable").find("#"+obj.destId).size() == 0){
                    var tr = '<tr><td id='+obj.destId+'><input type="hidden" name="grossMarginDistrictList['+index+'].districtId" value="'+obj.destId+'">'+obj.destId+'</td><td>'+obj.destName+'</td><td><a class="delAttribution">删除</a></td></tr>';
                    $("#attributionTable").append(tr);
                    index++;
                }
            }
        }
        destSelectDialog.close();
    }

    $(".delReceiver,.delAttribution").live("click",function(){
        var that = $(this);
        $.confirm("确认删除?",function(){
            that.closest("tr").remove();
        });
    });

    //打开选择归属地窗口
    $("#addAttribution").bind("click",function(){
        markDest = $(this).attr("id");
        markDestId = $("#attributionId").attr("id");
        var url = "/vst_admin/biz/attribution/selectAttributionList.do?multi=true";
        destSelectDialog = new xDialog(url,{},{title:"选择归属地",iframe:true,width:"1000",height:"600"});
    });


</script>