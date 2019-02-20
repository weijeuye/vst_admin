/**
 *vst_settlement 工具类
 *@author sangbowei
 *@date 2013-11-20
 */

var vst_settlement_util = {


    /**
     * 结算对象名称 聚焦时间
     */
    settlementEntityNameFocus:function (targetNode) {
        $("#settlementEntityName").live("focus",function () {
            $("#settlementEntityName").siblings("ul").remove();
            vst_settlement_util.commSettlementEntityListSuggest("#settlementEntityName","#settlementEntityCode","#settlementEntityBu","#settlementEntityType","#settlementEntityId","#settlementEntityDesc",
                "/vst_admin/tour/goods/goods/findSettlementEntityList.do?contractId="+$(targetNode).val()+"&buyoutFlag=N");
        });
    },

    /**
     * 结算对象名称 失焦时间
     */
    settlementEntityNameBlur:function () {
        $("#settlementEntityName").live("blur",function () {
            var nameValue = $("#settlementEntityName").val();
            var length = nameValue.length;
            if(length<=0){
                $("#settlementEntityName").val('');
                $("#settlementEntityBu").val('');
                $("#settlementEntityType").val('');
                $("#settlementEntityCode").val('');
                $("#settlementEntityId").val('');
                $("#settlementEntityDesc").text('');
            }
        });
    },

    resetSelectSettleEntityNameInput : function(){
        $("#settlementEntityName").val('');
        $("#settlementEntityBu").val('');
        $("#settlementEntityType").val('');
        $("#settlementEntityCode").val('');
        $("#settlementEntityId").val('');
        $("#settlementEntityDesc").text('');
    },

    settleEntityCommListSuggest:function (targetNode) {
        vst_settlement_util.commSettlementEntityListSuggest("#settlementEntityName","#settlementEntityCode","#settlementEntityBu","#settlementEntityType","#settlementEntityId","#settlementEntityDesc",
            "/vst_admin/tour/goods/goods/findSettlementEntityList.do?contractId="+$(targetNode).val()+"&buyoutFlag=N");
    },

    /**
     * 查询 合同对应的结算列表
     * @param showNode 显示姓名的控件
     * @param idNode 保存ID的控件，一般是个隐藏域
     */
    commSettlementEntityListSuggest : function(showNode,codeNode,buNode,typeNode,idNode,spanId,_url, _data,isClean){
        $(showNode).jsonSuggest({
            url : _url,
            maxResults : 10,
            minCharacters : 1,
            emptyKeyup:false,
            data:_data,
            onSelect : function(item) {
                if(null != idNode){
                    if(item.settleType=='BUYOUT' || item.settleType=='SELF' || item.settleType=='DEPOSIT'){
                        $("#settlementEntityName").val('');
                        $("#settlementEntityBu").val('');
                        $("#settlementEntityType").val('');
                        $("#settlementEntityCode").val('');
                        $("#settlementEntityId").val('');
                        $("#settlementEntityDesc").text('');
                        $.alert("请设置非买断结算对象");
                    }else{
                        $(showNode).val(item.name);
                        $(codeNode).val(item.code);
                        $(buNode).val(item.bu);
                        $(typeNode).val(item.settleType);
                        $(idNode).val(item.id);
                        $(spanId).text(item.desc);
                        $("#settlementEntityTd").find("i.error").hide();
                    }
                }
            }
        });
    },


    /**
     * 买断结算处理js
     */
    /**
     * 买断结算对象名称 聚焦时间
     */
    buyoutSettlementEntityNameFocus:function (targetNode) {
        $("#buyoutSettlementEntityName").live("focus",function () {
            $("#buyoutSettlementEntityName").siblings("ul").remove();
            vst_settlement_util.buyoutCommSettlementEntityListSuggest("#buyoutSettlementEntityName","#buyoutSettlementEntityCode","#buyoutSettlementEntityBu","#buyoutSettlementEntityType","#buyoutSettlementEntityId","#buyoutSettlementEntityDesc",
                "/vst_admin/tour/goods/goods/findSettlementEntityList.do?contractId="+$(targetNode).val()+"&buyoutFlag=Y");
        });
    },

    /**
     * 买断结算对象名称 失焦时间
     */
    buyoutSettlementEntityNameBlur:function () {
        $("#buyoutSettlementEntityName").live("blur",function () {
            var nameValue = $("#buyoutSettlementEntityName").val();
            var length = nameValue.length;
            if(length<=0){
                $("#buyoutSettlementEntityName").val('');
                $("#buyoutSettlementEntityBu").val('');
                $("#buyoutSettlementEntityType").val('');
                $("#buyoutSettlementEntityCode").val('');
                $("#buyoutSettlementEntityId").val('');
                $("#buyoutSettlementEntityDesc").text('');
            }

        });
    },

    buyoutResetSelectSettleEntityNameInput : function(){
        $("#buyoutSettlementEntityName").val('');
        $("#buyoutSettlementEntityBu").val('');
        $("#buyoutSettlementEntityType").val('');
        $("#buyoutSettlementEntityCode").val('');
        $("#buyoutSettlementEntityId").val('');
        $("#buyoutSettlementEntityDesc").text('');
    },

    buyoutSettleEntityCommListSuggest:function (targetNode) {
        vst_settlement_util.buyoutCommSettlementEntityListSuggest("#buyoutSettlementEntityName","#buyoutSettlementEntityCode","#buyoutSettlementEntityBu","#buyoutSettlementEntityType","#buyoutSettlementEntityId","#buyoutSettlementEntityDesc",
            "/vst_admin/tour/goods/goods/findSettlementEntityList.do?contractId="+$(targetNode).val()+"&buyoutFlag=Y");
    },

    /**
     * 查询 合同对应的结算列表
     * @param showNode 显示姓名的控件
     * @param idNode 保存ID的控件，一般是个隐藏域
     */
    buyoutCommSettlementEntityListSuggest : function(showNode,codeNode,buNode,typeNode,idNode,spanId,_url, _data,isClean){
        $(showNode).jsonSuggest({
            url : _url,
            maxResults : 10,
            minCharacters : 1,
            data:_data,
            emptyKeyup:false,
            onSelect : function(item) {
                if(null != idNode){
                    //如果不属于买断类型则提示重新选择
                    if(item.settleType=='BUYOUT' || item.settleType=='SELF' || item.settleType=='DEPOSIT'){
                        $(showNode).val(item.name);
                        $(codeNode).val(item.code);
                        $(buNode).val(item.bu);
                        $(typeNode).val(item.settleType);
                        $(idNode).val(item.id);
                        $(spanId).text(item.desc);
                    }else{
                        $("#buyoutSettlementEntityName").val('');
                        $("#buyoutSettlementEntityBu").val('');
                        $("#buyoutSettlementEntityType").val('');
                        $("#buyoutSettlementEntityCode").val('');
                        $("#buyoutSettlementEntityId").val('');
                        $("#buyoutSettlementEntityDesc").text('');
                        $.alert("请设置买断结算对象");
                    }
                }
            }
        });
    }
};
