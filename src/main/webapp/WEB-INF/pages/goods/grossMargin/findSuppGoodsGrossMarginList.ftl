<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">产品管理</a> &gt;</li>
            <li class="active">毛利率设置</li>
        </ul>
</div>

<div class="iframe_content">

    <div class="p_box box_info">
        <form method="post" action='/vst_admin/goods/grossMargin/showSuppGoodsGrossMarginList.do' id="searchForm">
            <table class="s_table">
                <tbody>
                <tr>
                    <td class="s_label">所属BU：</td>
                    <td class="w18">
                        <select name="bu" required>
                            <option value="">全部</option>
                        <#list buList as list>
                            <option value=${list.code!''} <#if list.code==bu>selected="selected"</#if> >${list.cnName!''}</option>
                        </#list>
                        </select>
                    </td>
                    <td class="s_label">品类：</td>
                    <td class="w18">
                        <select name="categoryId">
                            <option value="">全部</option>
                            <option  value="1"  <#if 1==categoryId>selected="selected" </#if>  >酒店</option>
                            <option  value="11" <#if 11==categoryId>selected="selected"</#if>  >景点门票</option>
                            <option  value="12"  <#if 12==categoryId>selected="selected"</#if>  >其他票</option>
                            <option  value="13"  <#if 13==categoryId>selected="selected"</#if>  >组合套餐票</option>
                            <option  value="15"  <#if 15==categoryId>selected="selected"</#if>  >跟团游</option>
                            <option  value="18"  <#if 18==categoryId>selected="selected"</#if>  >自由行</option>
                            <option  value="16"  <#if 16==categoryId>selected="selected"</#if>  >当地游</option>
                            <option  value="17"  <#if 17==categoryId>selected="selected"</#if>  >酒店套餐</option>
                        </select>
					</td>
                    <td class="s_label">操作人：</td>
                    <td class="w18">
                        <input type="text" name="operator" id="operator" value="${operator!''}">
                        <input type="hidden" name="creatorId" id="creatorId" value="${creatorId!''}">
                    </td>
                </tr>
                <tr>

                    <td class="s_label">所属分公司：</td>
                    <td class="w18">
                        <select name="filiale" required>
                            <option value="">全部</option>
                        <#list filialeList as list>
                            <option value=${list.code!''} <#if list.code==filiale>selected="selected"</#if>  >${list.cnName!''}</option>
                        </#list>
                        </select>
                    </td>
                    <td class=" operate mt10">
                        <a class="btn btn_cc1" id="search_button">查询</a>
                        <a class="btn btn_cc1" id="new_button">新增</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
    <!-- 主要内容显示区域\\ -->
<#if pageParam??>
	<#if pageParam.items?? &&  pageParam.items?size &gt; 0>
        <div class="p_box box_info">
            <table class="p_table table_center">
                <thead>
                <tr>
                    <th width="80px">编号</th>
                    <th>毛利基准</th>
                    <th>所属分公司</th>
                    <th>所属BU</th>
                    <th>操作人</th>
                    <th>操作时间</th>
                    <th width="350px">操作</th>
                </tr>
                </thead>
                <tbody>
					<#list pageParam.items as gross>
                    <tr >
                        <td>${gross.suppGoodsGrossMarginId!''} </td>
                        <td>${(gross.grossMargin/100)?string('0.00')} <#if gross.grossMarginType=='FIXED'>元<#else>%</#if></td>
                        <td>${gross.filiale!''} </td>
                        <td>${gross.bu!''} </td>
                        <td>${gross.creatorName!''} </td>
                        <td>${gross.createDate?string("yyyy-MM-dd HH:mm:ss")} </td>
                        <td class="oper">
                            <a href="javascript:void(0);" class="editProd" data="${gross.suppGoodsGrossMarginId!''}"  >编辑</a>
                            <a href="javascript:void(0);" class="delete" data="${gross.suppGoodsGrossMarginId!''}"  >删除</a>
                            <a href="javascript:void(0);" class="showLogDialog" param='parentId=${gross.suppGoodsGrossMarginId}&parentType=GROSS_MARGIN&sysName=VST' >操作日志</a>
                        </td>
                    </tr>
					</#list>
                </tbody>
            </table>
			<#if pageParam.items?exists>
                <div class="paging" >
				${pageParam.getPagination()}
                </div>
			</#if>

        </div><!-- div p_box -->
	<#else>
        <div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
	</#if>
</#if>
    <div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:200px;">
    </div>
    <!-- //主要内容显示区域 -->
</div>

<#include "/base/foot.ftl"/>
</body>
</html>

<script>
    vst_pet_util.superUserSuggest("#operator","#creatorId");
</script>
<script>

	var goodsGrossMarginAddDialog,goodsGrossMarginUpdateDialog;
    var destSelectDialog;
    //选择

    //查询
    $("#search_button").bind("click",function(){
        $("#searchForm").submit();
    });

    function confirmAndRefresh(result){
        if (result.code == "success") {
            pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                $("#searchForm").submit();
            }});
        }else {
            pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                $.alert(result.message);
            }});
        }
    };

    $("a.editProd").click(function (){
        var suppGoodsGrossMarginId = $(this).attr("data");
        goodsGrossMarginUpdateDialog = new xDialog("/vst_admin/goods/grossMargin/showUpdateSuppGoodsGrossMargin.do",{suppGoodsGrossMarginId:suppGoodsGrossMarginId},{title:"修改毛利率",width:900,height:700});
    });

    $("a.delete").click(function (){
        var suppGoodsGrossMarginId = $(this).attr("data");
        $.confirm("是否删除?",function(){
            $.ajax({
                url : "/vst_admin/goods/grossMargin/deleteSuppGoodsGrossMargin.do",
                type : "post",
                data : {"id":suppGoodsGrossMarginId},
                success : function(result) {
                    confirmAndRefresh(result);
                },
                error : function(){
                }
            })

        });
    });


    //新建
    $("#new_button").bind("click",function(){
        //打开弹出窗口
        goodsGrossMarginAddDialog = new xDialog("/vst_admin/goods/grossMargin/showAddSuppGoodsGrossMargin.do",{},{title:"设置毛利率",width:900,height:700});
        return;
    });

</script>