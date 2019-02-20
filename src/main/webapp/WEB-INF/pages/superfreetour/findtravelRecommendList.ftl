<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<#assign voa=JspTaglibs["/WEB-INF/pages//tld/vstOrgAuthentication-tags.tld"]>
<#assign vpa=JspTaglibs["/WEB-INF/pages//tld/productAbandon-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>宝典列表</title>

    <link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
    <link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
</head>
<body class="product-list">

<!--页面 开始-->
<div class="everything">

    <!--筛选 开始-->
    <div class="filter">
        <form class="filter-form" method="post" action='/vst_admin/prod/travelRecommend/findtravelRecommendList.do' id="searchForm">
            <div class="row">
                <div class="col w200">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block">宝典名称</span>
                            <input class="form-control w130" type="text" name="recommendName" value="${travelRecommend.recommendName!''}">
                        </label>
                    </div>
                </div>
                <div class="col w170">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block text-right">宝典ID</span>
                            <input class="form-control w90" type="text" name="recommendId" value="${travelRecommend.recommendId!''}" number="true" maxLength="11">
                        </label>
                    </div>
                </div>
                <div class="col w190">
                    <div class="form-group">
                        <label>
                            <span class="w80 inline-block text-right">宝典目的地</span>
                            <input class="form-control w90" type="text" name="destName" value="${travelRecommend.destName!''}" maxLength="11">
                        </label>
                    </div>
                </div>
                <div class="col w250">
                    <div class="form-group">
                        <label>
                            <span class="w70 inline-block text-right">产品经理</span>

                            <div class="inline-block">
                                <input class="search form-control w120" type="text" id="managerName" name="managerName" value="${travelRecommend.managerName!''}">
                                <input type="hidden" id="managerId" name="managerId" value="${travelRecommend.managerId!''}">
                            </div>
                        </label>
                    </div>
                </div>
                <div class="col w130">
                    <div class="form-group">
                        <label>
                            <span>宝典状态</span>
                            <select class="form-control" name="validFlag">
                                <option value="">不限</option>
                                <option value='Y'<#if travelRecommend.validFlag == 'Y'>selected</#if>>有效</option>
                                <option value='N'<#if travelRecommend.validFlag == 'N'>selected</#if>>无效</option>
                            </select>
                        </label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col w430"></div>
                <div class="col w400">
                    <span class="btn-group">
                    	<@mis.checkPerm permCode="3523" >
                        </@mis.checkPerm >
                            <a class="btn JS_show_dialog_category" id="new_button">新增</a>
                    	<a class="btn btn-primary JS_btn_select" id="search_button">查询</a>
                    </span>
                </div>
            </div>
        </form>
    </div>
    <!--筛选 结束-->

    <!--产品列表 开始-->
<#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>

        <div class="product">
            <table class="table table-border">
                <colgroup>
                    <col class="w30"/>
                    <col class="w90"/>
                    <col class="w90"/>
                    <col class="w60"/>
                    <col class="w40"/>
                    <col class="w20p"/>
                </colgroup>
                <thead>
                <tr>
                    <th class="text-center">宝典ID</th>
                    <th class="text-center">宝典名称</th>
                    <th class="text-center">宝典目的地</th>
                    <th class="text-center">产品经理</th>
                    <th class="text-center">宝典状态</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <#list pageParam.items as recommend>
                    <tr sensitive="${recommend.senisitiveFlag}">
                        <td class="text-center">${recommend.recommendId}</td>
                        <td>${recommend.recommendName!''}</td>
                        <td>${recommend.destName!''}</td>
                        <td class="text-center">${recommend.managerName!''}</td>
                        <td class="text-center" >
                            <#if recommend.validFlag == "Y">
                            <span class="text-success" data-tag="validFlagSpan" data-id="${recommend.recommendId}">有效
                            <#else>
                                <span class="text-danger" data-tag="validFlagSpan" data-id="${recommend.recommendId}">无效</span>
                            </#if>
                        </td>
                        <td class="oper">
                            <a href="javascript:void(0);" data-tag="editRecommend" data-id="${recommend.recommendId}" >编辑</a>
                            <a href="http://diy.lvmama.com/superfreetour/recommend/index.do?recommendId=${recommend.recommendId}&view=1" target="_blank" >预览</a>
                            <#if recommend.validFlag == "Y">
                                <a href="javascript:void(0);" data-tag="setValid" data-action="N" data-id="${recommend.recommendId}" >设为无效</a>
                            <#else>
                                <a href="javascript:void(0);" data-tag="setValid" data-action="Y" data-id="${recommend.recommendId}" >设为有效</a>
                            </#if>
                            <a href="javascript:void(0);" data-tag="viewLog" data-id="${recommend.recommendId}"  param='parentId=${recommend.recommendId}&parentType=TRAVEL_RECOMMEND&sysName=VST' >操作日志</a>
                        </td>
                    </#list>
                </tr>
                </tbody>
            </table>
            <#if pageParam.items?exists>
                <div class="page-box" > ${pageParam.getPagination()}</div>
            </#if>
        </div>

    <#else>
        <div class="hint mb10">
            <span class="icon icon-big icon-info"></span>抱歉，找不到相关查询结果哦
        </div>
    </#if>
</#if>
    <!--产品列表 结束-->
    <div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:200px;">
    </div>
</div>

</body>
</html>
<!--页面 结束-->
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>

<script>
    //遮蔽
    var loading;

    $(document).ready(function () {
        //加载产品经理选项
        vst_pet_util.superUserSuggest("#managerName","#managerId");

        //新增
        $("#new_button").click(function(){
            window.open("/vst_admin/prod/travelRecommend/showTravelRecommendMaintain.do");
        });

        //查询
        $("#search_button").click(function(){
            if(!$("#searchForm").validate().form()){
                return false;
            }
            $(".iframe-content").empty();
            $(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
            //去掉左右的空格
            $("input[name=recommendId]").val( $.trim($("input[name=recommendId]").val()));
            $("input[name=recommendName]").val( $.trim($("input[name=recommendName]").val()));
            $("input[name=destName]").val( $.trim($("input[name=destName]").val()));
            $("#searchForm").submit();
        });

        //编辑
        $("a[data-tag='editRecommend']").click(function(){
            window.open("/vst_admin/prod/travelRecommend/showTravelRecommendMaintain.do?travelRecommendId="+$(this).attr("data-id"));
        });

        //设为有效无效
        $("a[data-tag='setValid']").click(function(){
            loading = pandora.loading("正在努力保存中...");
            var theClick = $(this);
            var theSpan =$("span[data-tag='validFlagSpan'][data-id='"+$(this).attr("data-id")+"']");
            $.ajax({
                url : "/vst_admin/prod/travelRecommend/changeTravelRecommendValid.do",
                type : "post",
                dataType : 'json',
                data :{
                    recommedId:$(this).attr("data-id"),
                    validFlag:$(this).attr("data-action")
                },
                success : function(result) {
                    loading.close();
                    if(result.attributes && result.attributes.noRoute=="noRoute"){
                        pandora.dialog({wrapClass: "dialog-mini", content:"宝典必须有对应的行程才能设置为有效!", mask:true,okValue:"确定",ok:function(){
                        }});
                        return;
                    }
                    if(result.code == "success"){
                        if(theClick.attr("data-action")=="Y"){
                            theClick.attr("data-action","N");
                            theClick.text("设为无效");
                            theSpan.text("有效");
                            theSpan.removeClass("text-danger");
                            theSpan.addClass("text-success");
                        }else{
                            theClick.attr("data-action","Y");
                            theClick.text("设为有效");
                            theSpan.text("无效");
                            theSpan.removeClass("text-success");
                            theSpan.addClass("text-danger");
                        }
                        pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
                        }});
                    }else {
                        $.alert(result.message);
                    }
                },
                error : function(){
                    loading.close();
                }
            });
        });

        // 查看日志
        $("a[data-tag='viewLog']").click(function () {
            var param = $(this).attr("param");
            showLogDialog = new xDialog("/vst_ebooking/ebooking/user/suppGroup/back/showSupplierGroupLogs.do?"+param,{},{title:"日志",iframe:true,width:1000,hight:500,iframeHeight:680,scrolling:"yes"});
        });

    });


</script>
