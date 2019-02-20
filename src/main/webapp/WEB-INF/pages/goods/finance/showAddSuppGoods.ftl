<div class="iframe_content mt10">
    <#list qualifyTypeList as typeInfo>
        <input type="hidden" name="qualifyTypeListInputHidden" code="${typeInfo.code!''}" value="${typeInfo.cnName!''}">
    </#list>
    <#list lvAccSubjectList as accSubjectInfo>
        <input type="hidden" name="lvAccSubjectListInputHidden" code="${accSubjectInfo.code!''}" value="${accSubjectInfo.subName!''}">
    </#list>
    <form action="/vst_admin/finance/goods/addSuppGoods.do" method="post" id="dataForm">
        <input type="hidden" name="supplierId" value="${suppGoods.supplierId}">
        <input type="hidden" name="productId" value="${suppGoods.productId}">
        <input type="hidden" name="categoryId" value="${suppGoods.categoryId}">
        <input type="hidden" name="senisitiveFlag" value="N">
        <input type="hidden" name="productBranchId" value="${suppGoods.productBranchId}">
        <div class="p_box box_info p_line">
            <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
                    <tr>
                        <td width="150" class="e_label"><i class="cc1">*</i>商品名称：</td>
                        <td><label><input type="text" class="w35" style="width:500px" name="goodsName" id="goodsName"
                                          required="true" maxlength="70"></label>
                            <div id="goodsNameError"></div>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>内容维护人员：</td>
                        <td>
                            <input type="text" class="w350 searchInput" name="contentManagerName"
                                   id="contentManagerName" value="${suppGoods.contentManagerName}" required=true>
                            <input type="hidden" value="${suppGoods.contentManagerId}" name="contentManagerId"
                                   id="contentManagerId" required=true>
                            <span id="tips" style="display:none; color:red;">注：该处信息仅供参考，如需修改请至商品基础设置下进行维护</span>
                            <div id="managerNameError"></div>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>商品合同：</td>
                        <td>
                            <input type="hidden" name="companyType" id="companyTypeHidden"
                                   value="${suppGoods.companyType!''}"/>
                            <label id="contractNameAdd"
                                   name="contractName"> <#if suppGoods!=null && suppGoods.suppContract!=null>${suppGoods.suppContract.contractName}</#if></label>
                            <input type="hidden" id="contractIdAdd"
                                   name="contractId" <#if suppGoods!=null && suppGoods.suppContract!=null>
                                   value="${suppGoods.suppContract.contractId}"</#if>>
                            <a id="change_button_contract" href="javascript:void(0);">[更改]</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>结算对象：</td>
                        <td id="settlementEntityTd">
                            <input type="text" name="settlementEntityName"
                                   id="settlementEntityName" <#if suppGoods!=null && suppGoods.settlementEntity!=null>
                                   value="${suppGoods.settlementEntity.name}"</#if> required=true>
                            <input type="hidden" name="settlementEntityCode"
                                   id="settlementEntityCode" <#if suppGoods!=null && suppGoods.settlementEntity!=null>
                                   value="${suppGoods.settlementEntity.code}"</#if> required=true>
                            <input type="hidden" <#if suppGoods!=null && suppGoods.settlementEntity!=null>
                                   value="${suppGoods.settlementEntity.id}"</#if> name="settlementEntityId"
                                   id="settlementEntityId" required=true>
                            <span name="settlementEntityDesc" id="settlementEntityDesc">
					<#if suppGoods.settlementEntity!=null&&suppGoods.settlementEntity.code?? >
                        结算对象CODE: ${suppGoods.settlementEntity.code}
                    </#if>
					<#if suppGoods.settlementEntity!=null&&suppGoods.settlementEntity.cooperatedBuNostroName??>
                        ,合作BU：${suppGoods.settlementEntity.cooperatedBuNostroName}
                    </#if>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>我方结算主体：</td>
                        <td>
                            <span id="companyTypeNew" style="width:250px;">
                            <#if (suppGoods!=null) && (suppGoods.companyType!=null)&&(suppGoods.companyType!="") >
                            <#assign lvCode="" />
                            <#switch suppGoods.companyType>
                                <#case "JOYU">
                                    <#assign lvCode="DEFAULT" />
                                    <#break>
                                <#case "GUOLV">
                                    <#assign lvCode="LVMAMA" />
                                    <#break>
                                <#case "XINGLV">
                                    <#assign lvCode="LVMAMAXINGLV" />
                                    <#break>
                            </#switch>
                          <#list lvAccSubjectList as subjectInfo>
                              <#if subjectInfo.code==lvCode>
                                  ${subjectInfo.subName!''}
                              </#if>
                          </#list>
                            </#if>
                            </span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i for="companyTypeNew" id="contract_main"
                                                                           class="error"
                                                                           style="display:none">该字段不能为空</i>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>支付对象：</td>
                        <td>
                            <select name="payTarget" required>
                                <option value="">请选择</option>
		    				<#list payTargetList as list>
			                    <option value=${list.code!''}>${list.cnName!''}</option>
                            </#list>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>BU：</td>
                        <td>
                            <select name="bu" required>
                                <option value="">请选择</option>
						<#list buList as list>
		                	<option value=${list.code!''}>${list.cnName!''}</option>
                        </#list>
                            </select>
                        </td>
                    </tr>
                    <#include "/goods/finance/showDistributorGoods.ftl"/>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>最小起订数量：</td>
                        <td>
                            <input type="text" name="minQuantity" required=true value="1">
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>最大订购数量：</td>
                        <td>
                            <input type="text" name="maxQuantity" required=true>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>销售价：</td>
                        <td>
                            <input type="text" name="salesPrice" required=true>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label">库存：</td>
                        <td>
                            <input type="text" name="totalStock">
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</div>
<div class="p_box box_info clearfix mb20">
    <div class="fl operate" style="margin:20px;"><a class="btn btn_cc1" id="save">保存</a></div>
</div>
<script type="text/javascript" src="/vst_admin/js/vst_settlement_util.js"></script>
<script>
    vst_pet_util.superUserSuggest("#contentManagerName","input[name=contentManagerId]");
    vst_pet_util.superUserSuggest("#managerName","input[name=managerId]");
    vst_pet_util.superUserSuggest("#regionalLeaderName","input[name=regionalLeaderId]");
    vst_pet_util.superUserSuggest("#commercialStaffName","input[name=commercialStaffId]");


    <#-- SETTLE_ENTITY_NEW_MARK  start -->
    vst_settlement_util.settleEntityCommListSuggest("#contractIdAdd");
    vst_settlement_util.settlementEntityNameBlur();
    vst_settlement_util.settlementEntityNameFocus("#contractIdAdd");
    <#-- SETTLE_ENTITY_NEW_MARK  end -->
</script>
<script>
    var selectContractDialog2;
    //供应商合同回调函数
    function onSelectContract2(params){
        if(params!=null){
            $("#contractNameAdd").text(params.contractName);
            $("#contractIdAdd").val(params.contractId);
            var accCode =params.accSubject;
            //回调显示合同主体(取到合同的我方结算主体)
            var accSubjectCname='';
            $("input[name='lvAccSubjectListInputHidden']").each(function(){
                if(accCode==$(this).attr("code")){
                    accSubjectCname=$(this).val();
                }
            });
            $("#companyTypeHidden").val(lvSubjectCodeConvert(accCode));
            $("#companyTypeNew").html(accSubjectCname);
            $("#contract_main").attr("style", "display:none");

        <#-- SETTLE_ENTITY_NEW_MARK  start -->
            vst_settlement_util.resetSelectSettleEntityNameInput();
        <#-- SETTLE_ENTITY_NEW_MARK  end -->
        }
        selectContractDialog2.close();
    }
    //合同结算主体code转换
    function lvSubjectCodeConvert(lvAccSubjectCode){
        var returnCode="";
        switch(lvAccSubjectCode){
            case "DEFAULT":
                returnCode="JOYU";
                break;
            case "LVMAMA":
                returnCode="GUOLV";
                break;
            case "LVMAMAXINGLV":
                returnCode="XINGLV";
                break;
        }
        return returnCode;
    }
    //打开选择供应商合同列表
    $("#change_button_contract").click(function(){
        selectContractDialog2 = new xDialog("/vst_back/supp/suppContract/selectContractListBySupplier.do?callback=onSelectContract2&supplierId="+$("#supplierId").val(),{},{title:"选择供应商合同",width:"600"});
    });
    $(function(){
        //JQuery 自定义验证
        jQuery.validator.addMethod("isCharCheck", function (value, element) {
            var chars = /^([\u4e00-\u9fa5]|[a-zA-Z0-9]|[\+-]|[\u0020])+$/;//验证特殊字符
            return this.optional(element) || (chars.test(value));
        }, "不可为空或者特殊字符");

        // 中文字两个字节
        jQuery.validator.addMethod("byteRangeLength", function (value, element, param) {
            var length = value.length;
            for (var i = 0; i < value.length; i++) {
                if (value.charCodeAt(i) > 127) {
                    length++;
                }
            }
            return this.optional(element) || ( length >= param[0] && length <= param[1] );
        }, $.validator.format("请确保输入的值在{0}-{1}个字节之间(一个中文字算2个字节)"));
        /**
         * 验证数字
         */
        jQuery.validator.addMethod("isNumber", function(value, element) {
            var num = /^[1-9]\d*(\.\d{1,2})?$/;
            return this.optional(element) || (num.test(value));
        }, "请填写数字");
        /**
         * 验证正整数
         */
        jQuery.validator.addMethod("isInteger", function(value, element) {
            var num = /^[1-9]\d*|0$/;
            return this.optional(element) || (num.test(value));
        }, "请填写整数");

        var $document = $(document);
        //验证规则
        var fomeRules = {
            rules: {
                goodsName: {
                    isCharCheck: true,
                    byteRangeLength: [2, 140]
                },
                minQuantity: {
                    required : true,
                    min:1,
                    max:999
                },
                maxQuantity: {
                    required : true,
                    min:1,
                    max:99999999
                },
                salesPrice: {
                    isNumber:true,
                    min:0
                },
                totalStock: {
                    isInteger:true,
                    min:0
                }
            },
            messages: {
                goodsName: '请输入2~140个字符且不可为空或者特殊字符',
                salesPrice:'请输入数字',
                totalStock:'请输入整数'
            }
        };

        $("#save").click(function(){
            if (!$("#dataForm").validate(fomeRules).form()) {
                return false;
            }
            var distributorChecked = document.getElementById("distributorIds_4").checked;
            if(distributorChecked){
                var distributorUserIds = $("input:checkbox[name='distributorUserIds']:checked").val();
                if(typeof(distributorUserIds) =="undefined"){
                    alert("请选择super系统分销商.");
                    return false;
                }
            }
            if($("#contractIdAdd").val()==""){
                $.alert("请选择供应商合同！");
                return false;
            }
            if(parseInt($("input[name=maxQuantity]").val())<parseInt($("input[name=minQuantity]").val())){
                $.alert("最小订购数量不能大于最大订购数量！");
                return false;
            }
            $("input[name=goodsName]").val($.trim($("input[name=goodsName]").val()));
            var msg = '确认保存吗 ？';
            if(refreshSensitiveWord($("#dataForm").find("input[type='text'],textarea"))){
                $("input[name=senisitiveFlag]").val("Y");
                msg = '内容含有敏感词,是否继续?';
            }else {
                $("input[name=senisitiveFlag]").val("N");
            }
            $("#save").hide();
            $.confirm(msg,function(){
                $.ajax({
                    url : "/vst_admin/finance/goods/addSuppGoods.do",
                    type : "post",
                    data : $(".dialog #dataForm").serialize(),
                    success : function(result) {
                        if (!(result.code == "success")) {
                            $("#save").show();
                        }
                        confirmAndRefresh(result);
                    },
                    error : function(){
                        $("#save").show();
                    }
                });
            },function(){
                $("#save").show();
            });
        });
    })

</script>