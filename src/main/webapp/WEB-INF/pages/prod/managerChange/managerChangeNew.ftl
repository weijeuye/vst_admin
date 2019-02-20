<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<#assign voa=JspTaglibs["/WEB-INF/pages//tld/vstOrgAuthentication-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>产品列表</title>

    <link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>


    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
    <link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
</head>
<body class="product-list">

<form class="filter-form" method="post" id="searchForm" action="#">
    <!--页面 开始-->
    <div class="everything">

        <!--洋葱皮-->
        <ol class="onionskin">
            <li>
                <a href="#">首页</a>
                <i>&gt;</i>
            </li>
            <li>
                <a href="#">产品管理</a>
                <i>&gt;</i>
            </li>
            <li>
                产品归属变更
            </li>
        </ol>


        <!--筛选 开始-->
        <div class="filter">
            <div class="row">
                <div class="col">
                    <div class="form-group">
                        <label>

                            <span class="w90 inline-block text-right"><input  type="radio" name="selectProductRadio" id="magagerRadio">产品经理:</span>

                            <div class="inline-block">
                                <input class="search form-control" type="text" id="oldManagerName" value="${oldManagerName!''}">
                                <input type="hidden" id="oldManagerId" name="oldManagerId" value="${oldManagerId!''}">
                            </div>
                        </label>
                    </div>
                </div>
                <div class="col" >
                    <div class="form-group">
                    <label>
                        <input type="hidden" id="selectProductRadioFlag" name="selectProductRadioFlag" value="${selectProductRadioFlag!''}">
                        <span class="w90 inline-block text-right" style="vertical-align:top"><input  type="radio" name="selectProductRadio" id="productIdsRadio"  checked="checked">产品ID：</span>
                        <div    class="inline-block">
	                    	<textarea placeholder="产品编号中可输入多个产品ID，ID间用“，”分隔，可同时查询多个产品"
                                      id="productIds" maxlength="4000" class="textWidth" name="productIds" style="height:40px;width:500px;" value="${productIds}">${productIds}</textarea>
                        </div>
                    </label>
                    </div>
                </div>

            </div>
            <div class="row">
                <div class="col w200">
                    <div class="form-group">
                        <span class="w90 inline-block text-right">产品品类</span>

                        <select class="w80 inline-block text-right" name="categoryId" id="categoryId">
                            <option value="">线路</option>
                            <option value="15" <#if categoryId==15>selected="selected"</#if>>跟团游</option>
                            <option value="16" <#if categoryId==16>selected="selected"</#if>>当地游</option>
                            <option value="17" <#if categoryId==17>selected="selected"</#if>>酒店套餐</option>
                            <option value="18" <#if categoryId==18>selected="selected"</#if>>自由行</option>
                        </select>
                    </div>
                </div>
                <div class="col w200">
                    <div class="form-group">
                        <span class="w20 inline-block text-right">BU</span>

                        <select class="w120 inline-block text-right" name="buArray" id="buCode">
                            <option value="">不限</option>
                            <option value="LOCAL_BU,DESTINATION_BU" <#if buArray=='LOCAL_BU'>selected="selected"</#if>>国内事业度假部</option>
                            <option value="OUTBOUND_BU" <#if buArray=='OUTBOUND_BU'>selected="selected"</#if>>出境游事业部</option>
                        </select>
                    </div>
                </div>
                <div class="col w250">
                    <span class="btn-group">
                            <a class="btn btn-primary JS_btn_select" id="search_product_button">查询</a>
                    </span>
                </div>
            </div>

            <div class="row">
                <div class="col w400">

                    <span class="ml20 btn-group text-right">
                            <a class="btn btn-primary JS_btn_select " id="changeManager_button">变更</a>
                    </span>


                    <span class="ml20 btn-group text-right">
                            <a class="btn btn-primary JS_btn_select " id="changeManagerAll_button">变更所有</a>
                    </span>


                    <span class="ml20 btn-group text-right">
                            <a href="javascript:void(0)"  class="btn btn-primary JS_btn_select showLogDialog" id="queryOperator_button"  param='objectId=567891&objectType=MANAGER_CHANGE_OPRATE&logType=MANAGER_CHANGE_CATEORYSANDGOODS&sysName=VST'>查看操作日志</a>
                    </span>
                </div>

            </div>
        </div>

        <div>
            <span style="color: red;">*若只需变更该产品经理下的部分产品，请自行勾选需要变更的产品。</span>
        </div>
    </div>

    <!--产品列表 开始-->
<#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
        <div class="product">
            <table class="table table-border">
                <colgroup>
                    <col class="w50"/>
                    <col class="w100"/>
                    <col class="w100"/>
                    <col class="product-name"/>
                    <col class="w100"/>
                    <col class="w100"/>
                    <col class="w100"/>
                    <col class="w90"/>
                </colgroup>
                <thead>
                <tr><th>选择</th>
                    <th>品类</th>
                    <th>产品ID</th>
                    <th class="product-name">产品名称</th>
                    <th>产品经理</th>
                    <th>产品状态</th>
                    <th>是否可售</th>
                    <th>审核状态</th>
                    <th>推荐级别</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <#list pageParam.items as product>
                    <tr sensitive="${product.senisitiveFlag}">
                        <td class="text-center">
                            <input type="checkbox" name="productIdList" value="${product.productId!''}" />
                        </td>
                        <td class="text-center">${product.bizCategoryName}</td>
                        <td class="text-center">${product.productId!''}</td>
                        <td>${product.productName!''}</td>
                        <td>${product.managerName!''}</td>
                        <td class="text-center">
                            <#if product.cancelFlag == "Y">
                            <span class="text-success">有效
                            <#else>
                                <span class="text-danger">无效</span>
                            </#if>
                        </td>
                        <td class="text-center"><#if product.saleFlag =="Y">是<#else>否</#if></td>
                        <td>
                            <#if product.auditStatus??>
                                <#list auditTypeList as audit>
                                    <#if product?? && product.auditStatus==audit.code>${audit.cnName}</#if>
                                </#list>
                                <br/>
                                <#if product.senisitiveFlag=='Y'><span class="text-danger">(敏感词)</span></#if>
                            </#if>
                        </td>
                        <td class="text-center">${product.recommendLevel}</td>

                    </#list>
                </tr>
                </tbody>
            </table>
            <#if pageParam.items?exists>
                <div class="page-box"><span id="totalFront" style="">&nbsp;&nbsp;&nbsp;共计${pageParam.totalResultSize}条记录，每页最多显示15条记录</span> ${pageParam.getPagination()}</div>
            </#if>
            <div class="col w250">
                <span class="btn-group">
                    <a class="btn btn-primary " id="allCheck">当页全选</a>
                </span>
                <span class="btn-group">
                    <a class="btn btn-primary " id="changeManager_button1">变更</a>
                </span>
            </div>
        </div>
    <#else>
        <div class="hint mb10">
            <span class="icon icon-big icon-info"></span>抱歉，查询暂无数据
        </div>
    </#if>
</#if>
    <!--筛选 结束-->
</form>

</body>
</html>
<!--页面 结束-->
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>

<script>


    //vst_pet_util.superUserSuggest("#managerName","#managerId");
    vst_pet_util.superUserSuggest("#oldManagerName","#oldManagerId");
    var isChecked = false;  //默认未选中
    var changeManagerDialog;
    $(function () {

        //禁用“变更所有”
        $("#changeManagerAll_button").hide();
        //禁用产品经理
        $("#oldManagerName").attr("disabled","disabled");

        var selectProductRadioFlag = $("#selectProductRadioFlag").val();
        if (selectProductRadioFlag != null && selectProductRadioFlag !="") {
            $("#productIdsRadio").attr("checked", "checked");
            //$("#magagerRadio").removeAttr("checked");
            $("#productIds").removeAttr('disabled');
            $("#oldManagerName").attr("disabled","disabled");
            $("#changeManagerAll_button").hide();
        }else {
            //$("#productIdsRadio").removeAttr("checked");
            $("#magagerRadio").attr("checked", "checked");
            $("#oldManagerName").removeAttr('disabled');
            $("#productIds").attr("disabled","disabled");
            $("#changeManagerAll_button").show();
        }


        //查询产品
        $("#search_product_button").bind("click", function () {
            var oldManagerName=$("#oldManagerName").val();
            var oldManagerId = $("#oldManagerId").val();
           /* if(oldManagerName=="" || oldManagerId==""){
                $.alert("请选择产品经理");
                return;
            }*/
            var productIdsStr = $("#productIds").val();
            if (productIdsStr == "" && (oldManagerId=="" || oldManagerName == "")) {
                $.alert("产品ID和产品经理至少输入一项!");
                return;
            }
            var validateFlag = validateInput();
            if(!validateFlag){
                return;
            }
            $(".iframe-content").empty();
            $(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
            $("#searchForm").attr("action", "/vst_admin/prod/managerChange/findProductList.do");
            $("#searchForm").submit();
        });


        //更换产品经理
        $("#changeManagerAll_button").bind("click", function () {
            changeManagerDialog = new xDialog("/vst_admin/prod/managerChange/showManager.do?type=all",{},{title:"请选择交接产品经理",width:"340px",height:"190px"});
        });

        //更换产品经理
        $("#changeManager_button").bind("click", function () {
            changeManagerDialog = new xDialog("/vst_admin/prod/managerChange/showManager.do?type=checked",{},{title:"请选择交接产品经理",width:"340px",height:"190px"});
        });

        //更换产品经理
        $("#changeManager_button1").bind("click", function () {
            changeManagerDialog = new xDialog("/vst_admin/prod/managerChange/showManager.do?type=checked",{},{title:"请选择交接产品经理",width:"340px",height:"190px"});
        });

        $("#allCheck").bind("click", function () {
            if (!isChecked) {   //第一次点击选中全部
                $("input[name='productIdList']").attr("checked", "checked")
                isChecked = true;
            } else {
                $("input[name='productIdList']").removeAttr("checked")
                isChecked = false;
            }
        });

        $("#totalFront").prependTo($(".page-box div[class='Pages']"));
    });

    //更换产品经理
    function changeManager(newManagerName, newManagerId, type) {
        changeManagerDialog.close();

        if(newManagerName=="" || newManagerId==""){
            alert("请选择交接产品经理");
            return;
        }
        var confirmContent=null;
        $.ajax({
            url : "/vst_admin/prod/managerChange/queryOpeatorOfChangeManager.do",
            type : "post",
            dataType:"json",
            async: false,
            data : $("#searchForm").serialize()+"&newManagerName="+newManagerName+"&newManagerId="+newManagerId+"&type="+type,
            success:function(result){
                if(result.code=='bothNone'){
                    alert("没有要变更的数据");
                    return;
                }else if(result.code=='NoGOOds'){
                    alert("没有变更的商品");
                    return ;
                }else if(result.code=='NoSelected'){
                    alert("没有选择变更的数据");
                    return ;
                }else if(result.code=='NoProduct'){
                    alert("没有变更的商品");
                    return;
                } else if("paramException"==result.code) {
                    alert(result.message);
                } else if(result.code=='confirmContent'){
                    confirmContent = result.message;
                }else {
                    alert("系统异常");
                    return;
                }
            }
        })
        if(confirmContent!=null && confirm("确认"+confirmContent)){
            $.ajax({
                url : "/vst_admin/prod/managerChange/doChangeManager.do",
                type : "post",
                dataType:"json",
                async: false,
                data : $("#searchForm").serialize()+"&newManagerName="+newManagerName+"&newManagerId="+newManagerId+"&type="+type,
                success : function(result) {
                    if(result.code=='success'){
                        alert("产品经理变更成功");
                        window.location.reload();
                    }else if("paramException"==result.code){
                        alert(result.message);
                    }else if("error"==result.code){
                        alert("产品经理变更失败");
                    }
                }
            });
        }

    }
    //校验input合法
    function validateInput(){
        //产品id不得大于1000个
        var productIdsStr = $("#productIds").val();
        if(productIdsStr != null && productIdsStr != ""){
            var productIdsArr = productIdsStr.split(",");
            if(productIdsArr != null && productIdsArr.length>100){
                alert("最多一次查询100个产品！");
                return false;
            }
            var numberTest = /^[0-9]*[1-9][0-9]*$/;
            if(productIdsArr != null){
                for(var i=0;i<productIdsArr.length;i++){
                    if(!numberTest.test(productIdsArr[i])){
                        $.alert("请检查产品ID中【"+productIdsArr[i]+"】是否输入正确！");
                        return false;
                    }
                }
            }
        }

        return true;
    }

    //处理radio
    $("input[type=radio][name=selectProductRadio]").bind("click", function () {
        var that = $(this);
        var idVal = that.attr("id");
        if (idVal == "productIdsRadio") {
            //禁用“变更所有”
            $("#changeManagerAll_button").hide();
            $("#oldManagerName").attr("disabled","disabled");
            $("#oldManagerName").val("");
            $("#oldManagerId").val("");
            $("#productIds").removeAttr('disabled');
        }else {
            //启用“变更所有”
            $("#changeManagerAll_button").show();
            $("#oldManagerName").removeAttr('disabled');
            $("#productIds").attr("disabled","disabled");
            $("#productIds").val("");
        }
    });
</script>