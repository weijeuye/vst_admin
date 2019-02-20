<!DOCTYPE html>
<html lang="en">
<#include "/base/head_meta.ftl"/>
<head>
    <meta charset="UTF-8">
    <title>更换供应商</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/base.css,/styles/v5/modules/dialog.css,/styles/lv/icons.css,/styles/lv/tips.css,/styles/backstage/v1/common.css,/styles/v5/ebk.css,/styles/v5/zTreeStyle.css" rel="stylesheet">
    <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/dialog.css" type="text/css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/round/v1/vst-backstage-product.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/dialog.css,/styles/lv/buttons.css">
</head>
<body>
<div class="everything">
    <div class="frame-changeSupplier">
        <form>
            <dl>
                <dt><span class="c_red">*</span> 选择供应商:</dt>
                <dd><label><input type="text" id="supplierName" name="supplierName" class="form-control w270 search js_supplierName" placeholder="请输入供应商名称"></label></dd>
                <input type="hidden" id="supplierId" name="supplierId">
            </dl>
            <dl>
                <dt><span class="c_red">*</span> 产品所属组织:</dt>
                <dd>
                    <p>
                        <label><input type="text" class="w320 form-control" id="tempEbkSupplierGroupName" name="tempSupplierGroupName" disabled></label>
                        <input id="ebkSupplierGroupIdInput" name="ebkSupplierGroupId" type="hidden" class="input-text" type="text" />
                        <input id="oldSupplierGroupId" name="oldSupplierGroupId" type="hidden" />
                        <input id="oldSupplierGroupName" name="oldSupplierGroupName" type="hidden" />
                        <a href="javascript:" class="JS_choose_supp_group mr10" data-id="${prodSuppGoodsVO.ebkSupplierGroupId!''}" disabled>[更换所选组织]</a>
                        <a href="javascript:void(0);" class=" JS_reset_supp_group" data-id="${prodSuppGoodsVO.ebkSupplierGroupId!''}">重置</a>
                    </p>
                    <!--自己增加开始-->
                    <div id="retrieveSuppGroupContent" class="menuContent retrieveSuppGroupContent" style="display:none; position: absolute;">
                        <ul id="suppGroupTree" class="ztree" style="margin-top:0; width:160px;"></ul>
                    </div>
                    <!--自己增加结束-->
                    <p class="changeSupplier-tip">提示：请准确选择该产品所属组织，若当前无所需组织请先在EBK系统中添加所需组织。</p>
                </dd>
            </dl>
            <dl>
                <dt><span class="c_red">*</span> 商品合同:</dt>
                <dd>
                    <label><input type="text" class="form-control w270" disabled id="change_button_contrac_Name"></label>
                    <input type="hidden"  id="change_button_contrac_Id"  onpropertychange="">
                    <a href="javascript:" class="js_chooseContract" disabled id="change_button_contract">[选择合同]</a>
                    <p class="changeSupplier-mark" id="accSubjectCname"></p>
                    <input id="companyTypeHidden" type="hidden" name="companyType" >
                </dd>
            </dl>
            <dl>
                <dt><span class="c_red"></span>非预控自营/预控预存款结算对象：</dt>
                <dd id="settlementEntityTd">
                    <label><input type="text" class="form-control w270 search" name="settlementEntityName" id="settlementEntityName" disabled></label>
                    <input type="hidden" name="settlementEntityCode" id="settlementEntityCode"  >
                    <input type="hidden" name="settlementEntityId" id="settlementEntityId" >
                    <input type="hidden" name="settlementEntityBu" id="settlementEntityBu" >
                    <input type="hidden" name="settlementEntityType" id="settlementEntityType" >
                    <input type="hidden" name="settlementEntityCode" id="settlementEntityCode">
                    <p class="changeSupplier-mark" name="settlementEntityDesc" id="settlementEntityDesc"></p>
                </dd>
            </dl>

            <dl>
                <dt><span class="c_red"></span>预控自营/预控预存款结算对象：</dt>
                <dd id="buyoutSettlementEntityTd">
                    <label><input type="text" class="form-control w270 search" name="buyoutSettlementEntityName" id="buyoutSettlementEntityName" disabled></label>
                    <input type="hidden" name="buyoutSettlementEntityCode" id="buyoutSettlementEntityCode" >
                    <input type="hidden" name="buyoutSettlementEntityId" id="buyoutSettlementEntityId" >
                    <input type="hidden" name="buyoutSettlementEntityBu" id="buyoutSettlementEntityBu" >
                    <input type="hidden" name="buyoutSettlementEntityType" id="buyoutSettlementEntityType">
                    <p class="changeSupplier-mark" name="buyoutSettlementEntityDesc" id="buyoutSettlementEntityDesc"></p>
                </dd>
            </dl>
        </form>
    </div>


</div>
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/v5/modules/pandora-dialog.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/lv/dialog.js"></script>
<script type="text/javascript" src="http://pic.lvmama.com/js/v5/ebk_ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="http://pic.lvmama.com/js/v5/ebk_ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="http://pic.lvmama.com/js/v5/ebk_ztree/jquery.ztree.excheck.js"></script>
<#-- SETTLE_ENTITY_NEW_MARK  start -->
<script type="text/javascript" src="/vst_admin/js/vst_settlement_util.js?vsersion=201804121010"></script>
<#-- SETTLE_ENTITY_NEW_MARK  end -->

<script>
    $(function() {

        $(document).on('blur','#supplierName',function () {
            if("" !=$.trim($("#supplierName").val()) && "" !=$.trim($("#supplierId").val())){
                getSupplierGroup($.trim($("#supplierId").val()));
            }
        });

        $('.js_supplierName').bind("blur",function() {
            if ($("#supplierId").val() && $("#supplierId").val() != "") {

            } else {
                clearContractInfo();
                clearSettlementEntityInfo();
                clearSupplierGroupInfo();
            }
        });
        //搜索表单中显示组织树供用户选择
        $(".JS_choose_supp_group").bind('click', function () {
            if(!$("#supplierId").val() || $("#supplierId").val()==""){
                $.alert("请选择供应商!");
                return;
            }
            $("#retrieveSuppGroupContent").slideDown("fast");
            $("body").bind("mousedown", onBodyDown);
        });
        //重置搜索表单中组织树的选择
        $(".JS_reset_supp_group").bind('click', function () {
            $("#tempEbkSupplierGroupName").val('');
            $("#ebkSupplierGroupIdInput").val('');
        });


        //打开选择供应商合同列表
        $("#change_button_contract").click(function(){
            var supplierId =$("#supplierId").val();
            if(!supplierId || supplierId==""){
                $.alert("请选择供应商!");
                return;
            }
            var selectContractUrl="/vst_admin/prod/changeProductSupplier/selectContractListBySupplier.do?supplierId="+supplierId;
            showcontract(selectContractUrl);

        });
    });
    var supplierContractInfo={};
    function getSupplierContractInfo() {
        var supplierId =$("#supplierId").val();
        var supplierName =$("#supplierName").val();
        var contractName = $("#change_button_contrac_Name").val();
        var contractId = $("#change_button_contrac_Id").val();
        var supplierGroupName=$("#tempEbkSupplierGroupName").val();
        var supplierGroupId=$("#ebkSupplierGroupIdInput").val();
        var settlementEntityName=$("#settlementEntityName").val();
        var settlementEntityCode=$("#settlementEntityCode").val();
        var buyoutSettlementEntityCode=$("#buyoutSettlementEntityCode").val();
        var buyoutSettlementEntityName=$("#buyoutSettlementEntityName").val();
        var oldSupplierGroupName=$("#oldSupplierGroupName").val();
        var oldSupplierGroupId=$("#oldSupplierGroupId").val();
        var companyType=$("#companyTypeHidden").val();

        if(supplierId ==null || supplierId=="" ){
            $.alert("请选择供应商！");
            return;
        }
        if(supplierGroupId ==null || supplierGroupId=="" ){
            $.alert("请选择供应商所属组织！");
            return;
        }
        if(contractId ==null || contractId=="" ){
            $.alert("请选择商品合同！");
            return;
        }
        if((settlementEntityCode ==null || settlementEntityCode=="" ) && (buyoutSettlementEntityCode ==null || buyoutSettlementEntityCode=="" )){
            $.alert("请绑定一个结算对象！");
            return;
        }
        if($("#settlementEntityCode").val()!="" && $("#buyoutSettlementEntityCode").val()!="" && $("#settlementEntityBu").val() != $("#buyoutSettlementEntityBu").val()){
            $.alert("两个结算对象的合作BU不一致！");
            return;
        }

        supplierContractInfo.supplierId=supplierId;
        supplierContractInfo.supplierName=supplierName;
        supplierContractInfo.contractId=contractId;
        supplierContractInfo.contractName=contractName;
        supplierContractInfo.supplierGroupName=supplierGroupName;
        supplierContractInfo.supplierGroupId=supplierGroupId;
        supplierContractInfo.settlementEntityName=settlementEntityName;
        supplierContractInfo.settlementEntityCode=settlementEntityCode;
        supplierContractInfo.buyoutSettlementEntityCode=buyoutSettlementEntityCode;
        supplierContractInfo.buyoutSettlementEntityName=buyoutSettlementEntityName;
        supplierContractInfo.oldSupplierGroupName=oldSupplierGroupName;
        supplierContractInfo.oldSupplierGroupId=oldSupplierGroupId;
        supplierContractInfo.companyType=companyType;

        return supplierContractInfo;
    }

    //选择供应商合同
     function showcontract(selectContractUrl) {
        nova.dialog({
            url: true,
            content: selectContractUrl,
            okCallback: function () {
                $(".iframe1 iframe")[0].contentWindow.selecContract();
            },
            //okCallback: true,
            cancelCallback: true,
            okText: "确定",
            cancelText: "取消",
            okClassName: "btn-blue",
            title: "选择供应商合同",
            width: 775,
            initHeight: 200,
            wrapClass: 'changeSupplierDialog iframe1'
        });
    }
    //点击body隐藏下拉列表事件
    function hideMenu() {
        $("#retrieveSuppGroupContent").fadeOut("fast");
        $("body").unbind("mousedown", onBodyDown);
    }
    function onBodyDown(event) {
        if (!(event.target.id == "menuBtn" || event.target.id == "retrieveSuppGroupContent" || $(event.target).parents("#retrieveSuppGroupContent").length>0)) {
            hideMenu();
        }
    };
    //清除供应商组信息
    function clearSupplierGroupInfo() {
        $("#tempEbkSupplierGroupName").val("");
        $("#ebkSupplierGroupId").val("");
    };
    //清除合同信息
    function clearContractInfo() {
        $("#change_button_contrac_Name").val("");
        $("#change_button_contrac_Id").val("");
        $("#accSubjectCname").text("");
        $("#companyTypeHidden").val("");
    };
    //清除结算对象信息
    function clearSettlementEntityInfo() {
        $("#settlementEntityName").val("");
        $("#settlementEntityId").val("");
        $("#settlementEntityDesc").text("");
        $("#settlementEntityName").attr("disabled","disabled");

        $("#buyoutSettlementEntityName").val("");
        $("#buyoutSettlementEntityId").val("");
        $("#buyoutSettlementEntityDesc").text("");
        $("#buyoutSettlementEntityName").attr("disabled","disabled");

    }
    
    //查询表单中组织被选中时隐藏下拉列表
    function suppGroupChecked(e, treeId, treeNode) {
        var _newGroupName = treeNode.name,
                tempTreeNode = treeNode.getParentNode(),
                $ebkSupplierGroupIdInput = $("#ebkSupplierGroupIdInput");
        while(!!tempTreeNode){
            _newGroupName = tempTreeNode.name + " > " + _newGroupName;
            tempTreeNode = tempTreeNode.getParentNode();
        }

        var $tempSuppGroupName = $("#tempEbkSupplierGroupName");
        $tempSuppGroupName.attr("value", _newGroupName);
        hideMenu();
        $ebkSupplierGroupIdInput.val(treeNode.id);
    }
    function getSupplierGroup(supplierId){
        $.post("/vst_admin/prod/changeProductSupplier/getEbkSupplierGroupsByParams.do",{"supplierId": supplierId},function(data){
            var _selectTreeSetting = {
                view: {
                    dblClickExpand: false,
                    showIcon: false,
                    selectedMulti: false
                },
                data: {
                    simpleData: {
                        enable: true
                    }
                },
                callback: {
                    onClick: suppGroupChecked
                }
            };
            if(data){
                var supplierGroupId=data.baseNode.id=null?"":data.baseNode.id;
                var supplierGroupName=data.baseNode.name=null?"":data.baseNode.name;
                $("#oldSupplierGroupName").val(supplierGroupName);
                $("#oldSupplierGroupId").val(supplierGroupId);
                $("#tempEbkSupplierGroupName").val(supplierGroupName);
                $("#ebkSupplierGroupIdInput").val(supplierGroupId);
                $.fn.zTree.init($("#suppGroupTree"), _selectTreeSetting, data.nodeList);
            }
        },"json");
    }
</script>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
    vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}');
    <#-- SETTLE_ENTITY_NEW_MARK  start -->
    /*vst_settlement_util.settleEntityCommListSuggest("#change_button_contrac_Id");
    vst_settlement_util.settlementEntityNameBlur();
    vst_settlement_util.settlementEntityNameFocus("#change_button_contrac_Id");*/

    <#-- SETTLE_ENTITY_NEW_MARK  start -->
    vst_settlement_util.settleEntityCommListSuggest("#change_button_contrac_Id");
    vst_settlement_util.settlementEntityNameBlur();
    vst_settlement_util.settlementEntityNameFocus("#change_button_contrac_Id");
    vst_settlement_util.buyoutSettleEntityCommListSuggest("#change_button_contrac_Id");
    vst_settlement_util.buyoutSettlementEntityNameBlur();
    vst_settlement_util.buyoutSettlementEntityNameFocus("#change_button_contrac_Id");
    <#-- SETTLE_ENTITY_NEW_MARK  end -->
    <#-- SETTLE_ENTITY_NEW_MARK  end -->
</script>
