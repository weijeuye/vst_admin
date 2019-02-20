<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>主要负责人</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="main-director my-body">
    <p class="main-title">主要负责人</p>
    <div class="row">
    	<div class="col w15"></div>
    	<#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
    		<@mis.checkPerm permCode="5120">
	    		<a class="btn JS_btn_add">新增</a>
    		</@mis.checkPerm >
		</#if>
	</div>
    <input type="hidden" id="subCompanyId" value="${workforId!''}">
	<input type="hidden" id="viewType" value="${type!''}">
	<input type="hidden" id="auditType" value="${auditType!''}">
    <div class="main">
        <div>

            <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	            <table class="table table-border table_center">
	                <thead>
	                    <tr>
	                        <th width="95">序号</th>
	                        <th width="95">职务</th>
	                        <th width="95">姓名</th>
	                        <th width="105">手机</th>
	                        <th width="105">QQ号</th>
	                        <th width="180">邮箱</th>
	                        <th width="100">电话</th>
	                        <th width="120">操作</th>
	                    </tr>
	                </thead>
	                <tbody>
	            	<#list pageParam.items as principal>
	                    <tr>
	                        <td>
	                        	${principal.id!''}
								<#if type?upper_case=="COMPARED" && principal?? && auditType?upper_case=='SUBMITTED'>
									<#if !principal.approveTime??>
				                		<i class="icon icon-warning"></i> 
			                		<#elseif principal?? && principal.delForCompared == 'Y'>
			                			<i class="icon icon-danger"></i>
				                	</#if>
			                	</#if>
	                    	</td>
	                        <td>${principal.jobtitle!''}</td>
	                        <td>${principal.name!''}</td>
	                        <td>${principal.mobile!''}</td>
	                        <td>${principal.qq!''}</td>
	                        <td>
	                            <div class="w180 text-ellipsis">${principal.mail!''}</div>
	                        </td>
	                        <td>${principal.tel!''}</td>
	                        <td>
	                        	<#if type?upper_case=="COMPARED">
	                            	<@mis.checkPerm permCode="5121">
		                            	<a href="javascript:void(0);" data-type="COMPARED" class="mr5 JS_view_director" data-id="${principal.id!''}">查看</a>
	                            	</@mis.checkPerm >
                            	<#elseif type?upper_case!='COMPARED' && principal?? && principal.approveTime??>
                            		<@mis.checkPerm permCode="5119">
	                            		<a href="javascript:void(0);" data-type="READONLY" class="mr5 JS_view_director" data-id="${principal.id!''}">查看</a>
                        			</@mis.checkPerm >
	                            </#if>
	                            <#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
	                            	<@mis.checkPerm permCode="5120">
			                            <a href="javascript:void(0);" class="mr5 JS_edit_director" data-type="WRITABLE" data-id="${principal.id!''}">编辑</a>
			                            <a href="javascript:void(0);" class="mr5 JS_del_director" data-id="${principal.id!''}" data-workfortype="${principal.workforType!''}" data-workforid="${principal.workforId!''}">删除</a>
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
    var principalDialog;
    $(function() {

        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

        //新增负责人
        $document.on("click", ".JS_btn_add", addDirectorHanlder);
        function addDirectorHanlder() {
            var $this = $(this),
            	subComapnyId = $("#subCompanyId").val(),
            	type = $("#viewType").val(),
            	auditType = $("#auditType").val();
            var url = "/vst_admin/o2o/subCompany/principal.do?subCompanyId="+subComapnyId+"&type="+type+"&auditType="+auditType;
            principalDialog = backstage.dialog({
                width: 500,
                height: 530,
                title: "新增主要负责人",
                iframe: true,
                url: url
            });
        }

        //编辑负责人
        $document.on("click", ".JS_edit_director", editDirectorHanlder);
        function editDirectorHanlder() {
            var $this = $(this),
            	subComapnyId = $("#subCompanyId").val(),
            	type = $this.data("type"),
            	auditType = $("#auditType").val(),
            	id = $this.data("id");
        	var url = "/vst_admin/o2o/subCompany/principal.do?subCompanyId="+subComapnyId+"&type="+type+"&auditType="+auditType+"&id="+id;
            principalDialog = backstage.dialog({
                width: 500,
                height: 530,
                title: "编辑主要负责人",
                iframe: true,
                url: url
            });
        }

        //查看负责人
        $document.on("click", ".JS_view_director", editDirectorHanlder);

        // 删除操作
        $document.on("click", ".JS_del_director", delDirectorHanlder);
        function delDirectorHanlder() {
            var $this = $(this),
        		id = $this.data("id"),
        		workforType = $this.data("workfortype"),
        		workforId = $this.data("workforid");
    		var loading = backstage.loading({
			    title: "系统提醒消息",
			    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
			});
            var dialogDelete = backstage.confirm({
                content: "确认删除？",
                determineCallback: function() {
                	$.ajax({
						url : "/vst_admin/o2o/principal/remove.do",
						type : 'post',
						data : "id="+id+"&workforType="+workforType+"&workforId="+workforId,
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
						   		backstage.alert({
						   			content: result.message,
						   			callback: function(){
						   				$("#subco_principal", window.parent.document).parent("li").click();
						   			}
						   		});
							}
						},
						error : function(){
							backstage.alert({
								content: result.message,
					   			callback: function () {
					   				loading.destroy();
					   			}
							});
						}
				 	 })
                },
                cancelCallback: function(){
					loading.destroy();
				}
            });
        }

    });
    </script>
</body>

</html>
