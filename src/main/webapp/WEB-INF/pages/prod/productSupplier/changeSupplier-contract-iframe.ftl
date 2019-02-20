<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>更换供应商合同</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/iframe.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/base.css,/styles/v5/modules/dialog.css,/styles/lv/icons.css,/styles/lv/tips.css,/styles/backstage/v1/common.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/round/v1/vst-backstage-product.css">
</head>
<body>
<#list lvAccSubjectList as accSubjectInfo>
<input type="hidden" name="lvAccSubjectListInputHidden" code="${accSubjectInfo.code!''}" value="${accSubjectInfo.subName!''}">
</#list>
<div class="changeSupplier_contract">
    <form>
        <table class="p_table table_center js_check">
            <colgroup>
                <col class="w60">
                <col class="w140">
                <col class="w220">
                <col class="w80">
                <col class="w80">
                <col class="w80">
            </colgroup>
            <thead>
            <tr>
                <th>选择</th>
                <th>合同编号</th>
                <th>合同名称</th>
                <th>经办人</th>
                <th>产品经理</th>
                <th>合同有效期</th>
            </tr>
            </thead>
            <tbody>
            <#list suppContractList as contract>
            <tr class="selectContract">
                        <td>
                            <input type="radio" name="contract">
                            <input type="hidden" name="contractNameHide" value="${contract.contractName!''}">
                            <input type="hidden" name="contractIdHide" value="${contract.contractId!''}">
                            <input type="hidden" name="lvAccSubjectHide" value="${contract.suppSettleRule.lvAccSubject!''}" >
                        </td>

                <td><a href="javascript:void(0);" class="showContract" supplierId="${contract.supplierId}"
                       contractId="${contract.contractId}" >${contract.contractNo}</a>
                </td>
                <td>${contract.contractName!''} </td>
                <td>${contract.operatorName} </td>
                <td>${contract.managerName!''} </td>
                <td>${contract.endTimeStr!''} </td>
            </tr>
            </#list>

            </tbody>
        </table>
    </form>
</div>
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/v5/modules/pandora-dialog.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/lv/dialog.js"></script>
<script type="text/javascript" src="http://pic.lvmama.com/js/v5/ebk_ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="http://pic.lvmama.com/js/v5/ebk_ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="http://pic.lvmama.com/js/v5/ebk_ztree/jquery.ztree.excheck.js"></script>
<#-- SETTLE_ENTITY_NEW_MARK  start -->
<script type="text/javascript" src="/vst_admin/js/vst_settlement_util.js"></script>
</body>
</html>
<script>
    /**
     * 选择供应商合同操作
     */
    function  selecContract() {
        console.log($('.changeSupplier_contract tbody tr'));
        $('.changeSupplier_contract tbody tr').each(function () {
            var oldContractId=parent.$('#change_button_contrac_Id').val();
            if($(this).find("input[name='contract']").attr("checked")){
                var contractName=$(this).find("input[name='contractNameHide']").val();
                var contractId=$(this).find("input[name='contractIdHide']").val();
                parent.$("#change_button_contrac_Name").val(contractName);
                parent.$("#change_button_contrac_Id").val(contractId);
                if(contractId && contractId !=""){
                    if(oldContractId != contractId){
                        parent.$('#settlementEntityCode').val("");
                        parent.$('#settlementEntityName').val("");
                        parent.$('#settlementEntityDesc').text("");
                        parent.$('#buyoutSettlementEntityCode').val("");
                        parent.$('#buyoutSettlementEntityName').val("");
                        parent.$('#buyoutSettlementEntityDesc').text("");
                        parent.$("#companyTypeHidden").val("");
                    }
                    if(parent.$('#change_button_contrac_Id').val() && parent.$('#change_button_contrac_Id').val() !=""){
                        parent.$("#settlementEntityName").removeAttr("disabled");
                        parent.$("#buyoutSettlementEntityName").removeAttr("disabled");
                    }else {
                        parent.$("#settlementEntityName").attr("disabled","disabled");
                        parent.$("#buyoutSettlementEntityName").attr("disabled","disabled");
                    }
                }
                var lvAccSubject=$(this).find("input[name='lvAccSubjectHide']").val();
                //回调显示合同主体(取到合同的我方结算主体)
                var accSubjectCname='';
                $("input[name='lvAccSubjectListInputHidden']").each(function(){
                    if(lvAccSubject==$(this).attr("code")){
                        accSubjectCname=$(this).val();

                        parent.$("#accSubjectCname").html("*我方结算主体："+accSubjectCname);
                        parent.$("#companyTypeHidden").val(lvSubjectCodeConvert(lvAccSubject));
                    }

                });
            }
        });
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
</script>