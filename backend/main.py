import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.auth.views import router as auth_router
from app.register.views import router as register_router
from app.records.views import router as records_router
from app.homePage.views import router as homePage_router
from app.analysis.analyz_page import router as analysis_router
from app.analysis.advisor.health_advisor import router as advisor_router
from app.Mine.views import router as mine_router
app = FastAPI()

# 配置 CORS 中间件，允许跨域请求
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],  # 允许所有方法，当然你也可以限制方法
    allow_headers=["*"],  # 允许所有请求头
)

# 注册路由
app.include_router(auth_router, prefix="/auth", tags=["auth"])
app.include_router(register_router,prefix="/register",tags=["register"])
app.include_router(records_router,prefix="/records",tags=["records"])
app.include_router(homePage_router,prefix="/homePage",tags=["homePage"])
app.include_router(analysis_router, prefix="/analysis", tags=["analys"])
app.include_router(advisor_router, prefix="/analysis/advisor", tags=["advisor"])
app.include_router(mine_router,prefix="/mine",tags=["Mine"])

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)
