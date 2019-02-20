<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>关联公司信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="associated-company my-body">
    <div class="main">
        <div class="m10">
        	<#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	            <table class="table table-border">
	                <thead>
	                    <tr>
	                        <th width="225">股东方关联公司名</th>
	                        <th width="225">旅行社许可证号</th>
	                        <th width="120">第一负责人</th>
	                        <th width="115">手机</th>
	                        <th width="115">电话</th>
	                        <th width="60">操作</th>
	                    </tr>
	                </thead>
	                <tbody>
	                	<#list pageParam.items as item>
	                    <tr>
	                        <td>
	                            <div class="w225 text-ellipsis">${item.name!''}</div>
	                        </td>
	                        <td>${item.permitNo!''}</td>
	                        <td>${item.principalName!''}</td>
	                        <td>
	                            ${item.mobile!''}
	                        </td>
	                        <td>
	                            ${item.tel!''}
	                        </td>
	                        <td>
	                            <a class="mr5 JS_view_ps" data-id="${item.id}" data-type="READONLY">查看详情</a>
	                        </td>
	                    </tr>
	                    </#list>
	                </tbody>
	            </table>
	            <#if pageParam.items?exists> 
					<div class="page-box" > ${pageParam.getPagination()}</div> 
				</#if>
				
			<#else>
	            <div class="hint mb10">
	                <span class="icon icon-big icon-info"></span> 抱歉，查询暂无数据
	            </div>
        	</#if>
        </div>
    </div>
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script>
    $(function() {

        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

        // 查看股东关联公司详情操作
        $document.on("click", ".JS_view_ps", viewAssociatedCompanyHanlder);
        function viewAssociatedCompanyHanlder() {
            var $that = $(this),
        		id = $that.data("id"),
        		type = $that.data("type");
			window.open("/vst_admin/o2o/sholdAssCompany/showMaintain.do?companyId=" + id + "&type=" + type);
        }

    });
    </script>
</body>

</html>
