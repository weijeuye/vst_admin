<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>股东信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/shareholder-info.css"/>
</head>
<body class="shareholder-info">
    <div class="everything">
        <!--筛选 开始-->
        <div class="filter">
            <form class="filter-form clearfix" method="post" action='/vst_admin/o2o/shareholder/findList.do' id="searchSholdForm">
                <div class="col w800">
                    <div class="row">
                        <div class="col w180">
                            <div class="form-group">
                                <label>
                                    <span class="w60 inline-block text-right">股东</span>
                                    <input class="form-control w90" name="name" type="text" <#if shareholder??>value="${shareholder.name!''}"</#if>/>
                                </label>
                            </div>
                        </div>
                        <@mis.checkPerm permCode="5126,5127" permParentCode="5118">
                        <div class="col w180">
                            <div class="form-group">
                                <label>
                                    <span class="w60 inline-block text-right">股东方类型</span>
									<select name="sholdType" class="form-control w100">
            	 						<option value="">全部</option>
				    					<#list sholdTypes as list>
				                    		<option value=${list.code!''} <#if shareholder!=null && shareholder.sholdType==list.code>selected</#if> >${list.cnName!''}</option>
					                	</#list>
					        		</select>
                                </label>
                            </div>
                        </div>
                        <div class="col w180">
                            <div class="form-group">
                                <label>
                                    <span class="w60 inline-block text-right">股东方状态</span>
                                    <select class="form-control w90" name="sholdStatus">
	                   					<option value="">全部</option>
				                    	<option value='Y'<#if shareholder?? && shareholder.sholdStatus == 'Y'>selected</#if>>有效</option>
				                    	<option value='N'<#if shareholder?? && shareholder.sholdStatus == 'N'>selected</#if>>无效</option>
		                            </select>
                                </label>
                            </div>
                        </div>
                        <input name="writablePerm" type="hidden" value="true"/>
                        </@mis.checkPerm >
                         <div class="col w180">
                            <div class="form-group">
                                <label>
                                    <span class="w60 inline-block text-right">审核状态</span>
									<select name="auditStatus" class="form-control w100">
            	 						<option value="">全部</option>
				    					<#list auditTypes as list>
				                    		<option value=${list.code!''} <#if shareholder!=null && shareholder.auditStatus==list.code>selected</#if> >${list.cnName!''}</option>
					                	</#list>
					        		</select>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="pull-right">
                    <div class="btn-group">
                    	<a class="btn btn-primary" id="search_button">查询</a>
                    	<@mis.checkPerm permCode="5126">
                        	<a class="btn" id="new_shareholder">新增</a>
                        </@mis.checkPerm >
                    </div>
                </div>
            </form>
        </div>
        <!--筛选 结束-->

        <div class="si-table">
            <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	            <table class="table table-border table_center">
	                <thead>
	                <tr>
	                    <th width="100">序号</th>
	                    <th width="300">股东方</th>
	                    <th width="160">股东方类型</th>
	                    <th width="100">股东方状态</th>
	                    <th width="100">审核状态</th>
	                    <th width="240">操作</th>
	                </tr>
	                </thead>
	                <tbody>
	            		<#list pageParam.items as shareholder>
			            <tr>
		                    <td>
		                    	${shareholder.id!''}
		                    	<#if shareholder?? && shareholder.auditStatus=='SUBMITTED' && !shareholder.approveTime?exists>
		                    		<i class="icon icon-warning"></i> 
		                    	</#if>
	                    	</td>
		                    <td>
		                        <div class="w300 text-ellipsis">
		                            ${shareholder.name!''}
		                        </div>
		                    </td>
		                    <td>
		                    	<#if shareholder.sholdType??>
									<#list sholdTypes as list>
							        	<#if shareholder?? && shareholder.sholdType==list.code>${list.cnName!''}</#if>
				                	</#list>
		                		</#if>
							</td>
		                    <td>
		                    	<#if shareholder.sholdStatus == "Y">
				               		<span class="text-success">有效
				                <#else>
				                	<span class="text-danger">无效</span>
				                </#if>
		                    </td>
		                    <td>
								<#if shareholder.auditStatus??>
									<#list auditTypes as audit>
					            			 <#if shareholder?? && shareholder.auditStatus==audit.code>${audit.cnName}</#if>
					            	</#list>
				            	</#if>
							</td>
		                    <td>
		                    	<@mis.checkPerm permCode="5125">
		                    		<#if shareholder?? && shareholder.approveTime??>
		                        		<a href="javascript:void(0);" class="mr5 JS_view_shareholder" data-id="${shareholder.id}" data-type="READONLY">查看</a>
		                        	</#if>
		                        </@mis.checkPerm >
	                        	<#if shareholder?? && shareholder.auditStatus!='SUBMITTED'>
			                        <@mis.checkPerm permCode="5126">
		                        		<a href="javascript:void(0);" class="mr5 JS_update_shareholder" data-id="${shareholder.id}" data-type="WRITABLE">编辑</a>
			                        </@mis.checkPerm >
			                    </#if>
		                        <#if shareholder?? && shareholder.auditStatus=='SUBMITTED'>
			                        <@mis.checkPerm permCode="5127">
		                        		<a href="javascript:void(0);" class="mr5 JS_audit_shareholder" data-id="${shareholder.id}">审核</a>
			                        </@mis.checkPerm >
			                        <@mis.checkPerm permCode="5126">
		                        		<a href="javascript:void(0);" class="mr5 JS_cancel_audit_shareholder" data-id="${shareholder.id}">撤销审核</a>
			                        </@mis.checkPerm >
			                        <@mis.checkPerm permCode="5127">
		                        		<a href="javascript:void(0);" class="mr5 JS_shareholder_comparison" data-id="${shareholder.id}" data-type="COMPARED">审核内容</a>
			                        </@mis.checkPerm >
	                        	</#if>
	                        	<#if shareholder?? && shareholder.auditStatus=='NOT_SUBMIT'>
			                        <@mis.checkPerm permCode="5126">
		                        		<a href="javascript:void(0);" class="mr5 JS_submit_audit_shareholder" data-id="${shareholder.id}">提交审核</a>
			                        </@mis.checkPerm >
	                        	</#if>
		                        <@mis.checkPerm permCode="5126,5127" permParentCode="5118">
		                        	<a href="javascript:void(0);" class="mr5 JS_operate_log" data-param="{'parentId':${shareholder.id},'parentType':'SHOLD'}">操作日志</a>
		                        </@mis.checkPerm >
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
                <span class="icon icon-big icon-info"></span>
                抱歉，查询暂无数据
            </div>
            </#if>
        </div>
    </div>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script>
    var auditFormDialog,
        searchHandler;
    $(function () {
        var $document = $(document);

        <#if errorMsg??>
        	backstage.alert({
   		  		content: "${errorMsg}"
   		  	});
        </#if>

        searchHandler = function () {
			$("input[name=name]").val( $.trim($("input[name=name]").val()));
	        <@mis.checkPerm permCode="5126,5127" permParentCode="5118">
				$("input[name='sholdStatus']").val( $.trim($("input[name='sholdStatus']").val()));
			</@mis.checkPerm >

			$("#searchSholdForm").submit();
        }
        // 查询股东信息列表
        $document.on("click", "#search_button", searchHandler);

        //新增股东
        $document.on("click", "#new_shareholder", addShareholderHanlder);
        function addShareholderHanlder() {
			window.open("/vst_admin/o2o/shareholder/showMaintain.do");
        }

		var eventHandler = function(){
			var $that = $(this),
        		id = $that.data("id"),
        		type = $that.data("type");
			window.open("/vst_admin/o2o/shareholder/showMaintain.do?shareholderId=" + id + "&type=" + type);
		}

        // 查看股东信息
        $("a.JS_view_shareholder").bind("click",eventHandler);

        // 编辑股东信息
        $("a.JS_update_shareholder").bind("click",eventHandler);

		var submitOrCancelAudit = function (msg, data) {
			var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
			backstage.confirm({
				content: msg,
				determineCallback: function(){
					$.ajax({
						url : "/vst_admin/o2o/shareholder/audit.do",
						type : 'post',
						dataType : 'json',
						data : data,
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
								backstage.alert({
									content: result.message,
									callback: searchHandler
								});
							}else {
								backstage.alert({
									content: result.message
								});
							}
						},
						error : function(result){
							backstage.alert({
								content: result,
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

        // 提交审核股东信息
        $("a.JS_submit_audit_shareholder").bind("click",function(){
			var id=$(this).data("id");
			submitOrCancelAudit("是否提交审核？",{"id": id, "auditStatus": "SUBMITTED"});
		});

        // 审核股东信息
        $document.on("click", ".JS_audit_shareholder", viewShareholderHanlder);
        function viewShareholderHanlder() {
			var id=$(this).data("id");
			var url = "/vst_admin/o2o/shareholder/showAduitDialog.do?id="+id;
            auditFormDialog = backstage.dialog({
                width: 800,
                height: 400,
                title: "提交审核结果",
                iframe: true,
                url: url
            });
        }
        // 撤销审核股东信息
        $("a.JS_cancel_audit_shareholder").bind("click",function(){
			var id=$(this).data("id");
			submitOrCancelAudit("是否撤销审核？", {"id": id, "auditStatus": "NOT_SUBMIT"});
		});

        // 审核股东信息内容
        $("a.JS_shareholder_comparison").bind("click",eventHandler);

        // 操作日志
        $("a.JS_operate_log").bind("click",function(){
			var param=$(this).data("param");
			var url = "/vst_admin/o2o/findOperateLogs.do?param="+param;
            backstage.dialog({
                width: 1000,
                height: 600,
                title: "日志详情页",
                iframe: true,
                url: url
            });
		});
    });

</script>
</body>
</html>
