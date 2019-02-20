        <form action="/vst_admin/o2o/materials.do" id="materialsForm" name="materialsForm" method="POST" enctype="multipart/form-data">
        	<input name="parentType" type="hidden" value="${objectType}"/>
        	<input name="parentId" type="hidden" value="${objectId}"/>
        	<input name="serverType" type="hidden" value="COM_AFFIX"/>
        	<input name="subCompanyId" type="hidden" value="${subCompanyId}"/>
        	<input name="delIds" type="hidden"/>
            <dl class="clearfix">
                <dt>
                    <label for="">
                        证照材料：
                    </label>
                </dt>
                <dd class="contracts_dd" data-type="materials">
                	<#-- 如果是审核内容则先显示被删除的 -->
               		<#if type?upper_case == 'COMPARED'>
	                    <#list oldMaterialsList as item>
	                    	<#if !materialsIds?seq_contains(item.id)>
			                    <div class="files-uploaded">
			                        <div class="file-input-group clearfix">
		                            	<i class="icon icon-danger"></i>
			                            <a class="w200 fg-link-name" href="/vst_admin/pet/ajax/file/downLoad.do?fileId=${item.fileId}" title="${item.name} ${item.createTime?string('yyyy-MM-dd')}">${item.name}</a>
			                        </div>
			                    </div>
	                    	</#if>
	                	</#list>
                	</#if>
                    <#list materialsList as item>
	                    <div class="files-uploaded">
	                        <div class="file-input-group clearfix">
	                            <#if type?upper_case == 'COMPARED'>
	                            	<#if !item.approveTime??>
		                            	<i class="icon icon-warning"></i>
		                            </#if>
	                            </#if>
	                            <a class="w200 fg-link-name" href="/vst_admin/pet/ajax/file/downLoad.do?fileId=${item.fileId}" title="${item.name} ${item.createTime?string('yyyy-MM-dd')}">${item.name}</a>
	                            <#if type?upper_case == 'WRITABLE'>
	                            	<a class="btn fg-del-btn JS_del_uploaded_file" data-param=${item.id}>删除</a>
	                            </#if>
	                        </div>
	                    </div>
                	</#list>
                	<#if type?upper_case == 'WRITABLE'>
	                    <div class="file-input-group clearfix">
	                        <input name="" type="text" class="form-control w200 fg-name"/>
	                        <a class="btn fg-del-btn">删除</a>
	                        <a class="btn btn-primary fg-upload-btn">点击上传</a>
	                        <input name="materials" type="file" multiple class="w310 fg-file-input" accept=".doc,.docx,.xls,.xlsx,.pdf,.jpg,.jpeg,.png" />
	                    </div>
                    </#if>
                </dd>
                <div class="row"></div>
                <dt>
                    <label for="">
                        内部交接材料：
                    </label>
                </dt>
                <dd class="contracts_dd" data-type="internalFile">
                	<#-- 如果是审核内容则先显示被删除的 -->
                	<#if type?upper_case == 'COMPARED'>
	                    <#list oldInternalFileList as item>
	                    	<#if !materialsIds?seq_contains(item.id)>
			                    <div class="files-uploaded">
			                        <div class="file-input-group clearfix">
		                            	<i class="icon icon-danger"></i>
			                            <a class="w200 fg-link-name" href="/vst_admin/pet/ajax/file/downLoad.do?fileId=${item.fileId}" title="${item.name} ${item.createTime?string('yyyy-MM-dd')}">${item.name}</a>
			                        </div>
			                    </div>
	                    	</#if>
	                	</#list>
                	</#if>
                    <#list internalFileList as item>
	                    <div class="files-uploaded">
	                        <div class="file-input-group clearfix">
	                            <#if type?upper_case == 'COMPARED'>
	                            	<#if !item.approveTime??>
		                            	<i class="icon icon-warning"></i>
		                            </#if>
	                            </#if>
	                            <a class="w200 fg-link-name" href="/vst_admin/pet/ajax/file/downLoad.do?fileId=${item.fileId}" title="${item.name} ${item.createTime?string('yyyy-MM-dd')}">${item.name}</a>
	                            <#if type?upper_case == 'WRITABLE'>
	                            	<a class="btn fg-del-btn JS_del_uploaded_file" data-param=${item.id}>删除</a>
	                            </#if>
	                        </div>
	                    </div>
                	</#list>
                	<#if type?upper_case == 'WRITABLE'>
	                    <div class="file-input-group clearfix">
	                        <input name="" type="text" class="form-control w200 fg-name"/>
	                        <a class="btn fg-del-btn">删除</a>
	                        <a class="btn btn-primary fg-upload-btn">点击上传</a>
	                        <input name="internalFile" type="file" multiple class="w310 fg-file-input" accept=".doc,.docx,.xls,.xlsx,.pdf,.jpg,.jpeg,.png" />
	                    </div>
                    </#if>
                </dd>
            </dl>
            <#if type?upper_case == 'WRITABLE'>
	            <p class="upload-warn-text">
	                注：上传格式为：word、excel、pdf、jpg、jpeg、png文件
	            </p>
            </#if>
        </form>
    </div>
    <!--模板 开始-->
    <div class="template">
        <div class="file-input-group clearfix">
            <input name="" type="text" class="form-control w200 fg-name" />
            <a class="btn fg-del-btn">删除</a>
            <a class="btn btn-primary fg-upload-btn">点击上传</a>
            <input name="" type="file" class="w310 fg-file-input" multiple accept=".doc,.docx,.xls,.xlsx,.pdf,.jpg,.jpeg,.png" />
        </div>
    </div>
    <!--模板 结束-->
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script>
    $(function() {

        var $document = $(document);
        var $template = $(".template");

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: ${errorMsg}
		  	});
	    </#if>

        // 添加资质
        $document.on('change', '.fg-file-input', function() {
            var $this = $(this);
            var $group = $this.parent('.file-input-group');
            var $contractsDd = $this.parents(".contracts_dd");
            $this.hide();
            $group.find('.fg-upload-btn').hide();
            $group.find('.fg-del-btn').show();
            var path = $this.val();
            var name = path.substring(path.lastIndexOf("\\") + 1);
            $group.find('.fg-name').val(name);

            var $tem = $template.find('.file-input-group').clone();
            $tem.find('.fg-file-input').attr('name',$contractsDd.data("type"));
            $contractsDd.append($tem);
        	changeFlag += 1;
        });

        // 删除之前已有的文件
        $document.on('click', '.fg-del-btn', function() {
            var param = $(this).data("param");
            if(!!param) {
	            delIds.push(param);
            } else {
            	changeFlag = changeFlag - 1;
            }
        });

    });
    </script>
</body>

</html>
