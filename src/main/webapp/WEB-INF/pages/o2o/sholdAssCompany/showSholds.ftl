<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
	<title>股东方</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="parent-shareholder my-body">
	<input type="hidden" id="companyId" <#if companyId??>value=${companyId}</#if> />
	<p class="main-title">股东方</p>
    <div class="row">
    	<div class="col w15"></div>
		<#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
			<@mis.checkPerm permCode="5123">
    			<a class="btn JS_add_ps">新增</a>
			</@mis.checkPerm >
		</#if>
	</div>
    <div class="main">
        <div>
            <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	            <table class="table table-border table_center">
	                <thead>
	                    <tr>
	                        <th width="95">序号</th>
	                        <th width="150">股东方</th>
	                        <th width="130">股东方类型</th>
	                        <th width="80">资质</th>
	                        <th width="240">备注</th>
	                        <th width="200">操作</th>
	                    </tr>
	                </thead>
	                <tbody>
	                <#list pageParam.items as item>
	                    <tr>
	                    	<td>
	                        	${item.id!''}
								<#if type?upper_case=='COMPARED' && item??>
									<#if !item.relApproveTime??>
				                		<i class="icon icon-warning"></i> 
			                		<#elseif item?? && item.delRelForCompared == 'Y'>
			                			<i class="icon icon-danger"></i>
				                	</#if>
			                	</#if>
	                    	</td>
	                        <td>
	                            <div class="w150 text-ellipsis">
									${item.name!''}
								</div>
	                        </td>
	                        <td>
								<#if item.sholdType??>
									<#list sholdTypes as list>
							        	<#if item?? && item.sholdType==list.code>${list.cnName!''}</#if>
				                	</#list>
		                		</#if>
							</td>
	                        <td>${item.aptitude!''}</td>
	                        <td>
	                            <div class="w240 text-ellipsis">${item.remarks!''}</div>
	                        </td>
	                        <td>
	                            <a class="mr5 JS_view_ps" data-id="${item.id}" data-type="READONLY">查看详情</a>
	                            <#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
	                            	<@mis.checkPerm permCode="5123">
	                            		<a class="mr5 JS_del_ps" data-relid="${item.relId}">删除</a>
                            		</@mis.checkPerm >
	                            </#if>
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
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script>
    var sholdAssCompanyDialog,
    	sholdIds = [];
    $(function() {

        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

        // 删除操作
        $document.on("click", ".JS_del_ps", delParentShareholderHanlder);
        function delParentShareholderHanlder() {
        	var $that = $(this),
        		companyId = $("#companyId").val(),
        		relId = $that.data("relid");
    		var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
            var dialogDelete = backstage.confirm({
                content: "确认删除？",
                determineCallback: function() {
                	$.ajax({
					url : "/vst_admin/o2o/sholdAssCompany/sholdRel/remove.do",
					type : 'post',
					data : "companyId="+companyId+"&relId="+relId,
					success : function(result) {
						loading.destroy();
						if(result.code == "success"){
							backstage.alert({
				   		  		content: result.message,
				   		  		callback: function(){
						    		$("#asso_co_shold", window.parent.document).parent("li").click();
						   		}
				   		  	});
						}
					},
					error : function(result){
						backstage.alert({
			   		  		content: result.message,
			   		  		callback: function () {
			   		  			loading.destroy();
			   		  		}
			   		  	});
					}
				  })
                },
                cancelCallback: function () {
                	loading.destroy();
                }
            });
        }

        // 新增操作
        $document.on("click", ".JS_add_ps", addSholdAssCompanyHanlder);
        function addSholdAssCompanyHanlder() {
            var $this = $(this),
            	companyId = $("#companyId").val();

        	var url = "/vst_admin/o2o/sholdAssCompany/findReadOnlySholdList.do?companyId="+companyId;
            sholdAssCompanyDialog = backstage.dialog({
                width: 840,
                height: 530,
                title: "新增",
                iframe: true,
                url: url
            });
        }

        // 查看股东详细信息
        $document.on("click", ".JS_view_ps", viewShareholderHanlder);
        function viewShareholderHanlder() {
            var $that = $(this),
        		id = $that.data("id"),
        		type = $that.data("type");
			window.open("/vst_admin/o2o/shareholder/showMaintain.do?shareholderId=" + id + "&type=" + type);
        }
    });
    </script>
</body>

</html>
