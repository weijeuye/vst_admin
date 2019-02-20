<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>活动查询页</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/v5/modules/paging.css"/>

</head>
<body class="active">
<div class="active_wrap">
    <form class="form-group" id="searchForm" action="/vst_admin/prod/destinationAnnouncement/queryList.do" method="post">
        <div class="activeFilter">
            <div class="row clearfix">
                <div class="col w150">
                    <label>
                        <span class="w50 inline-block">公告ID：</span>
                        <input class="form-control w85" name="announcementId" id="announcementId" value="${announcementId!''}" type="text">
                    </label>
                </div>
                <div class="col w185">
                    <label>
                        <span class="w65 inline-block">公告名称：</span>
                        <input class="form-control w105" name="announcementName" value="${announcementName!''}" type="text">
                    </label>
                </div>
                <div class="col w180">
                    <label>
                        <span class="w60 inline-block">产品ID：</span>
                        <input class="form-control w105" name="productId" id="productId" value="${productId!''}" type="text">
                    </label>
                </div>

                <div class="col w160">
                    <label>
                        <span class="w70 inline-block">是否有效：</span>
                        <select class="form-control w85" name="isValid">
                            <option value = "">全部</option>
                            <option value = "Y" <#if isValid!=null && isValid=='Y'>selected</#if>>有效</option>
                            <option value = "N"<#if isValid!=null && isValid=='N'>selected</#if>>无效</option>
                        </select>
                    </label>
                </div>
            </div>
        </div>
        <div class="active_btn w400">
                <span class="btn-group">
                    <a class="btn btn-primary JS_add_baseInform" id="add_button">新增</a>
                    <a class="btn btn-primary JS_btn_select" id="search_button">查询</a>
                    <a class="btn btn-primary JS_btn_select" id="search_button">刷新</a>
                </span>
        </div>
    </form>
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>

        <div class="product">
            <table class="table table-border">
                <colgroup>
                    <col class="w70"/>
                    <col class="product-name"/>
                    <col class="w100"/>
                    <col class="w100"/>
                    <col class="w70"/>
                    <col class="w70"/>
                    <col class="w20p"/>
                </colgroup>
                <thead>
                <tr>
                    <th>公告ID</th>
                    <th class="product-name">公告名称</th>
                    <th>开始展示时间</th>
                    <th>结束展示时间</th>
                    <th>是否有效</th>
                    <th>绑定产品数量</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <#list pageParam.items as announcement>
                    <tr>
                        <td class="text-center">${announcement.id}</td>
                        <td class="text-center">${announcement.announcementName}</td>
                        <td>${announcement.startDate?string('yyyy-MM-dd')}</td>
                        <td>${announcement.endDate?string('yyyy-MM-dd')}</td>
                        <td class="text-center">
                            <#if announcement.isValid == "Y">
                            <span class="text-success">有效
                            <#else>
                                <span class="text-danger">无效</span>
                            </#if>
                        </td>
                        <td class="text-center">${announcement.bindProductCount}</td>


                        <td class="oper">
                            <a href="javascript:void(0);" class="viewAnnouncement" data="${announcement.id}">编辑</a>
                            <a href="javascript:void(0);" class="bindProduct" data="${announcement.id}">绑定产品</a>
                            <a href="javascript:void(0);" class="findBindProduct" data="${announcement.id}">查询已绑定</a>
                            <a href="javascript:void(0);" class="setIsValid" data="${announcement.id}">
                                <#if announcement.isValid == "Y">
                                    设为无效</a>
                                <#else>
                                    设为有效</a>
                                </#if>
                            <a class="product-link JS_show_dialog_operationLog" param='parentId=${announcement.id}&parentType=PROD_DESC_ANNOUNCEMENT&sysName=VST'>操作日志</a>
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
            <span class="icon icon-big icon-info"></span>抱歉，查询暂无此公告
        </div>
    </#if>
    </#if>
</div>
<#--<div class="template">
    <div class="dialog-editBaseInformation">
        <iframe src="about:blank" class="iframe-editBaseInformation" frameborder="0"></iframe>
    </div>
</div>-->
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/common.js"></script>
<!--<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/active.js"></script>-->
<script type="text/javascript" src="/vst_admin/js/promotion/active.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script src="http://s3.lvjs.com.cn/js/ui/lvmamaUI/lvmamaUI.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js"></script>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<#include "/base/foot.ftl"/>
<script type="text/javascript">
    $(function(){

        var addAnnouncementDialog;
        var ddddd;
        var dddddg;

        $(".viewAnnouncement").click(function(){

            var announcementId = $(this).attr("data");
            var url = "/vst_admin/prod/destinationAnnouncement/toEdit.do?id="+announcementId;
            addAnnouncementDialog = new xDialog(url,{},{title:"新增公告",iframe:true,width:1000,hight:530});
        });
        $(".bindProduct").click(function(){
            var announcementId = $(this).attr("data");
            var url = "/vst_admin/prod/destinationAnnouncement/toBind.do?id="+announcementId;
            ddddd = new xDialog(url,{},{title:"绑定产品",iframe:true,width:1000,hight:730});
        });
        $(".findBindProduct").click(function(){
            var announcementId = $(this).attr("data");
            var url = "/vst_admin/prod/destinationAnnouncement/queryBindingProductList.do?announcementId="+announcementId;
            dddddg = new xDialog(url,{},{title:"已绑定产品",iframe:true,width:1000,hight:730});
        });

        //操作日志
        $(".JS_show_dialog_operationLog").bind("click", function () {
            var param=$(this).attr('param');
            new xDialog("/lvmm_log/bizLog/showVersatileLogList?"+param,{},{title:"日志详情页",iframe:true,width:890,hight:500,scrolling:"yes"});
        })

        $(".setIsValid").click(function(){
            var announcementId = $(this).attr("data");
            $.ajax({
                url: "/vst_admin/prod/destinationAnnouncement/setValid.do?announcementId="+announcementId,
                type: "POST",
                cache: false,
                dataType : 'json',
                success:
                        function(data){
                            if(data.code=="success"){
                                var $div = $('.Pages');
                                var page=0;
                                page = $div.find(".PageSel").text();
                                var url = $div.attr('url');
                                url += '&page=' + page;
                                window.location.href=url;
                                backstage.alert({
                                    content:"保存成功"
                                });
                            }else{
                                backstage.alert({
                                    content:"保存失败"
                                });
                            }
                        },
                error: function () {
                    backstage.alert({
                        content:"保存失败"
                    });
                }
            });
        });
        $(".viewLog").click(function(){

        });

        //查询
        $(".JS_btn_select").click(function(){
        	var re=/^[0-9]*[1-9][0-9]*$/; 
        	var announcementId = $("#announcementId").val();
			if(announcementId!=""&&(!re.test(announcementId))){
	   			alert("公告ID不符合要求");
	   			return;
	   		}
			var productId = $("#productId").val();
			if(productId!=""&&(!re.test(productId))){
	   			alert("产品ID不符合要求");
	   			return;
	   		}
            $("#searchForm").submit();
        });

        //新增
        $(".JS_add_baseInform").click(function(){
            var url = "/vst_admin/prod/destinationAnnouncement/toAdd.do";
            addAnnouncementDialog = new xDialog(url,{},{title:"新增公告",iframe:true,width:1000,hight:530});
        });

        function clearData(self) {
            var $hidden = self.$input.parent().find(".JS_autocomplete_f_hidden");
            $hidden.val("");
        }

    })

</script>
</body>
</html>
