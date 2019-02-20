<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
    <link rel="stylesheet" href="/vst_admin/css/ui-panel.css">
</head>
<body>
<!-- 顶部导航\\ -->
<div class="pg_topbar">
    <h1 class="pg_title">添加宝典</h1>
</div>
<!-- 边栏\\ -->
<div class="pg_aside">
    <div class="aside_box">
        <!-- <h2 class="f16">宝典维护</h2> -->
        <ul class="pg_list J_list">
            <li class="active"><a target="iframeMain" href='javascript:void(0);' id="traveRecommendBaseInfo">基本信息</a>
                <input type="hidden" id="isView" value="${isView}">
                <input type="hidden" id="travelRecommendId" value="${travelRecommendId}">
                <input type="hidden" id="recommendName" value="${recommendName}">
            </li>
            <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="traveRecommendRouteGuide">编辑导语</a></li>
            <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="traveRecommendRoute">编辑行程</a></li>
            <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="traveRecommendRule">资源组合规则设置</a></li>
        </ul>
    </div>
</div>
<!-- //工作区 -->
<div class="pg_main" style="height:93%;">
    <iframe id="iframeMain" name="iframeMain" src="" frameborder="0" style=" height:100%; background:#fff"></iframe>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
    var categorySelectDialog;
    $(document).ready(function(){

        var $LI = $(".J_list").find("li"),
                $IFRAME = $("#iframeMain");

        $LI.click(function () {
            $LI.removeClass("active");
            $(this).addClass("active");

        });

        checkAndJump();
        $("#traveRecommendBaseInfo").parent("li").click(function(){
            checkAndJump();
        });

        //编辑宝典导语
        $("#traveRecommendRouteGuide").parent("li").click(function(){
            var travelRecommendId = $("#travelRecommendId").val();
            if(travelRecommendId==""){
                $.alert("请先创建宝典");
                return false;
            }
            $("#iframeMain").attr("src","/vst_admin/superfreetour/travelRecommendGuide/showUpdateTravelRecommendGuide.do?recommendId="+travelRecommendId);
        });
        
        //编辑宝典行程
        $("#traveRecommendRoute").parent("li").click(function(){
            var travelRecommendId = $("#travelRecommendId").val();
            if(travelRecommendId==""){
                $.alert("请先创建宝典");
                return false;
            }
            $("#iframeMain").attr("src","/vst_admin/superfreetour/travelRecommendRoute/showTravelRoute.do?recommendId="+travelRecommendId);
        });

        //资源组合规则设置
        $("#traveRecommendRule").parent("li").click(function(){
            var travelRecommendId = $("#travelRecommendId").val();
            if(travelRecommendId==""){
                $.alert("请先创建宝典");
                return false;
            }
           $("#iframeMain").attr("src","/vst_admin/superfreetour/travelRecommendTrafficRule/showUpdatetravelRecommendTrafficRule.do?recommendId="+travelRecommendId);
        });
    });


    //判断是修改还是添加
    function checkAndJump(){
        //判断有没有产品ID
        var travelRecommendId = $("#travelRecommendId").val();
        if(travelRecommendId==""){
            $("#iframeMain").attr("src","/vst_admin/prod/travelRecommend/showAddTravelRecommend.do?timestamp="+Math.random(10));
        }else{
            $(".pg_title").html("修改宝典"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"宝典名称："+$("#recommendName").val()+"   "+"宝典ID："+$("#travelRecommendId").val());
            $("#iframeMain").attr("src","/vst_admin/prod/travelRecommend/showAddTravelRecommend.do?travelRecommendId="+travelRecommendId+"&timestamp="+Math.random(10));
        }
    }

</script>