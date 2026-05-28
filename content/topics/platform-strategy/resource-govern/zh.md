# 企业服务器与 SSD 资源节约路径研究：基于官方技术文档的客观分析

## 摘要

企业服务器资源与 SSD 资源的节约，实质上涉及计算、内存、网络、本地临时存储、块存储、容器镜像、日志、数据库文件以及未使用资源的持续治理。AWS Well-Architected 成本优化支柱将“选择正确的资源类型、大小和数量”列为成本优化内容，并说明资源右型化需要基于工作负载与资源属性数据；AWS Compute Optimizer、Azure Advisor、Google Cloud Recommender 均提供对过度配置、闲置资源或可调整资源的识别能力。容器化场景中，Kubernetes 通过 requests、limits、HPA、ephemeral-storage 与 ResourceQuota 等机制对 CPU、内存与临时存储进行声明、调度、限制和伸缩。SSD 资源治理方面，Linux `fstrim`、Kubernetes ephemeral storage、Docker prune、PostgreSQL VACUUM、MySQL OPTIMIZE TABLE、MongoDB compact 等官方机制均与未使用块、临时文件、镜像层、数据库死元组或过期块的回收有关。本文依据上述官方文档，对企业节省服务器资源与 SSD 资源的技术路径进行客观归纳。([AWS 文档][1])

**关键词：** 服务器资源；SSD；右型化；Kubernetes；临时存储；数据压缩；资源回收；成本优化

## 1. 引言

企业服务器资源通常包括 vCPU、物理 CPU、内存、网络带宽、实例规格、节点数量与容器副本数量；SSD 资源通常包括本地 SSD、云块存储 SSD、容器写入层、临时目录、日志、数据库数据文件、索引文件与快照数据。官方云平台文档将资源节约问题归入资源右型化、闲置资源识别、实例缩容或关停、磁盘类型与容量调整、IOPS 与吞吐配置等范畴。AWS Cost Explorer 的 rightsizing recommendations 用于识别 EC2 实例降配或终止机会；Azure Advisor 的成本建议用于识别空闲和低利用率资源；Google Compute Engine 的 idle resource recommendations 用于识别空闲 Persistent Disk、IP 地址和自定义镜像，并给出减少浪费和避免不必要费用的建议。([AWS 文档][2])

本文将“节省服务器资源”界定为：在满足工作负载技术要求的前提下，减少过度配置的计算、内存、网络与节点容量；将“节省 SSD 资源”界定为：减少过度配置的 SSD 容量、未使用块、未使用镜像层、未使用卷、数据库膨胀、无上限临时写入和不必要快照。AWS Well-Architected 文档明确说明，选择合适的资源类型、大小和数量，可以用最低成本资源满足技术要求，并且右型化是基于资源属性、工作负载和变更因素的迭代过程。([AWS 文档][1])

## 2. 服务器资源节约的官方依据与技术路径

### 2.1 基于利用率数据进行实例右型化

企业在云服务器或虚拟机层面节省服务器资源，首先依赖利用率数据与规格匹配。AWS Compute Optimizer 对 EC2 实例的分类包括 Under-provisioned、Over-provisioned、Optimized 和 None；其中 Over-provisioned 表示至少一项规格，如 CPU、内存或网络，可以在满足工作负载性能要求的同时下调。该定义直接支持通过识别过度配置实例来减少服务器资源占用。([AWS 文档][3])

Azure Advisor 对虚拟机或虚拟机规模集提供“调整大小或关闭低利用率实例”的成本建议，并显示调整大小或关闭后的估算成本节省；对于调整大小建议，Advisor 提供当前 SKU 与目标 SKU 或实例数量信息。该机制对应企业对低利用率服务器进行降配、减少实例数量或关停的资源节约操作。([微软学习][4])

Google Cloud 的 idle VM recommendations 根据观察期内的 CPU 与网络使用情况判断 VM 是否空闲；当 CPU 与网络使用量低于预设阈值时，Recommender 会将 VM 分类为空闲。Google Cloud 的机器类型建议可在控制台中显示，并允许对实例应用建议以修改机器类型；使用 Ops Agent 时，CPU、内存、网络、磁盘和进程指标可用于更精确的机器类型建议。([Google Cloud Documentation][5])

### 2.2 基于自动伸缩减少固定容量冗余

固定服务器容量通常需要按照峰值负载预留资源，而自动伸缩机制以指标驱动容量变化。AWS EC2 Auto Scaling 的动态伸缩策略会跟踪指定的 CloudWatch 指标，并在关联告警进入 ALARM 状态时执行动作；该机制可用于基于需求变化扩容或缩容实例。([AWS 文档][6])

Kubernetes Horizontal Pod Autoscaler 支持基于 Pod 资源使用率对目标对象进行扩缩容。Kubernetes 文档说明，HPA 使用 Pod 的资源请求值计算资源利用率，例如 CPU 利用率目标 60% 时，HPA 控制器会尝试将目标对象中 Pod 的平均利用率维持在该值附近；利用率是当前资源使用量与 Pod 请求资源量之间的比率。([Kubernetes][7])

在 Kubernetes 集群节点层面，Cluster Autoscaler 的官方 FAQ 说明，当某些节点在较长时间内持续不需要时，集群自动伸缩器会降低集群规模；节点被视为不需要的条件包括利用率较低，并且其重要 Pod 可迁移到其他节点。该机制对应企业减少空闲节点数量的服务器资源治理路径。([GitHub][8])

### 2.3 通过 requests、limits 与配额约束容器资源占用

Kubernetes 允许为容器指定 CPU、内存、巨大页和本地临时存储等资源的 requests 与 limits。资源 request 用于调度，limit 用于约束容器可使用的最大资源量；Kubernetes CPU 任务文档说明，容器不能使用超过所配置 CPU limit 的 CPU，并且只要系统有空闲 CPU 时间，容器可以保证获得其请求的 CPU。([Kubernetes][9])

在命名空间治理中，Kubernetes ResourceQuota 可用于限制命名空间的总体资源使用，LimitRange 可用于补充约束。Kubernetes 文档还说明，如果未设置 `emptyDir` 的 `sizeLimit`，该卷可能最多消耗到 Pod 的内存 limit；如果未设置内存 limit，则 Pod 在内存消耗上没有上限，可能耗尽节点可用内存。该事实说明，企业若未声明资源边界，节点级服务器资源与本地存储资源均可能被单个工作负载消耗。([Kubernetes][10])

## 3. SSD 资源节约的官方依据与技术路径

### 3.1 控制云 SSD 容量、IOPS 与吞吐的过度配置

云块存储中的 SSD 资源不仅包括容量，也包括 IOPS 与吞吐能力。AWS Compute Optimizer 会为 EBS 卷生成卷类型、卷大小、IOPS 与吞吐建议；建议页会列出当前卷规格、推荐卷规格、推荐 IOPS、推荐月度价格以及当前配置与推荐配置之间的价格差异。该机制支持企业基于利用率数据调整 SSD 卷类型、容量与性能参数。([AWS 文档][11])

AWS EBS gp3 官方说明显示，gp3 卷的 IOPS 与吞吐可独立于存储容量进行配置；EBS 定价页还说明，gp3 卷按配置的 GB 月计费，额外 IOPS 与吞吐也可独立配置并计费。该事实支持将容量需求与性能需求分离，避免通过扩大 SSD 容量来获得并不需要的性能。([Amazon Web Services, Inc.][12])

Azure Premium SSD v2 支持独立设置容量、吞吐和 IOPS；Microsoft 文档说明，每个值都会决定磁盘成本，Premium SSD v2 的容量范围为 1 GiB 到 64 TiB，并按 GiB 比例计费。Azure Premium SSD 的性能层可在部署时或部署后变更，且可在不改变磁盘大小的情况下变更性能层。该事实支持通过磁盘类型、性能层与容量的独立管理减少 SSD 资源过度配置。([微软学习][13])

Google Compute Engine 可识别空闲 Persistent Disk、IP 地址和自定义镜像，并提供建议以减少浪费和避免不必要费用。该机制对应企业对未挂载、长期未使用或低价值 SSD 块存储资源进行识别和清理。([Google Cloud Documentation][14])

### 3.2 使用文件系统 discard/TRIM 回收未使用块

Linux `fstrim` 官方 man page 说明，`fstrim` 用于在已挂载文件系统上 discard 或 trim 未被文件系统使用的块，并且该操作对 SSD 与精简配置存储有用；默认情况下，`fstrim` 会 discard 文件系统中的所有未使用块。Red Hat 文档也说明，batch discard 和 online discard 是已挂载文件系统对未使用块进行 discard 的功能，适用于 SSD 和精简配置存储，batch discard 通过 `fstrim` 命令显式运行。([man7.org][15])

因此，在企业 Linux 服务器、虚拟机或数据库主机中，SSD 资源回收并不等同于删除文件；删除文件后，文件系统知道块已空闲，而底层 SSD 或精简配置后端是否获知这些块可回收，取决于 discard/TRIM 是否被执行。该事实由 Linux `fstrim` 对“未使用块”的定义与用途直接支持。([man7.org][15])

### 3.3 限制容器临时存储、镜像层和日志对 SSD 的占用

Kubernetes 文档说明，Pod 使用本地临时存储作为 scratch space、缓存和日志；本地临时数据包括 `emptyDir`、可写容器层、容器镜像和日志等内容。Kubernetes 允许为每个容器设置 `resources.requests.ephemeral-storage` 与 `resources.limits.ephemeral-storage`；调度器会确保已调度容器的本地临时存储 request 之和小于节点容量。([Kubernetes][16])

当 kubelet 正在管理本地临时存储资源时，它会度量 `emptyDir`、节点级日志目录和可写容器层的使用量；如果 Pod 使用的 ephemeral storage 超过允许值，kubelet 会设置驱逐信号并触发 Pod 驱逐。该机制表明，企业可通过 ephemeral-storage request、limit、`emptyDir.sizeLimit` 与 ResourceQuota 对容器在 SSD 上产生的临时写入、日志和可写层进行边界控制。([Kubernetes][16])

Docker 官方文档说明，`docker system prune` 是清理镜像、容器和网络的快捷命令；默认不会清理 volumes，若需要清理 volumes 必须指定 `--volumes`。该命令会移除停止的容器、未被容器使用的网络、悬空镜像和未使用的构建缓存；使用 `--volumes` 时还会移除未被至少一个容器使用的卷。该事实对应企业对构建机、CI 节点、测试服务器和长期运行容器主机上的 SSD 占用治理。([Docker Documentation][17])

### 3.4 治理数据库文件膨胀与索引占用

数据库文件通常是企业 SSD 占用的重要来源。PostgreSQL 官方文档说明，标准 `VACUUM` 会移除表和索引中的 dead row versions，并将空间标记为可供将来复用；但在多数情况下不会把空间返还给操作系统。`VACUUM FULL` 会将表完整重写为没有额外空间的新磁盘文件，从而使未使用空间可返还给操作系统，但它更慢并且需要对每个表持有 `ACCESS EXCLUSIVE` 锁。([PostgreSQL][18])

MySQL 官方文档说明，在删除 MyISAM 或 ARCHIVE 表的大量数据、或对包含可变长度列的表进行大量变更后，可以使用 `OPTIMIZE TABLE` 回收未使用空间并对数据文件进行碎片整理；对于 InnoDB 表，`OPTIMIZE TABLE` 映射为 `ALTER TABLE ... FORCE`，会重建表以更新索引统计信息并释放聚簇索引中的未使用空间。([MySQL开发者专区][19])

MongoDB 官方文档说明，`compact` 命令会尝试通过将 obsolete blocks 释放回操作系统来减少集合数据和索引占用的磁盘空间；其效果取决于可释放块数量以及这些块在数据文件中的位置。该事实说明，NoSQL 数据库在大量删除或更新后，同样需要基于数据库自身机制处理 SSD 上的数据文件与索引空间回收。([mongodb.com][20])

## 4. 企业实施框架

企业节省服务器资源与 SSD 资源的实施框架可按“识别—约束—伸缩—回收—验证”的顺序建立。识别阶段依赖 AWS Compute Optimizer、Azure Advisor、Google Cloud Recommender 等工具发现过度配置、空闲或低利用率服务器与块存储。约束阶段在 Kubernetes 中配置 CPU、内存、ephemeral-storage 的 requests、limits、ResourceQuota 与 LimitRange。伸缩阶段使用 HPA、Cluster Autoscaler 或云平台 Auto Scaling 根据指标改变副本数、节点数或实例数。回收阶段使用 `fstrim`、Docker prune、数据库 VACUUM/OPTIMIZE/compact、空闲磁盘删除或卷右型化处理 SSD 占用。验证阶段使用云账单、资源利用率、磁盘利用率、IOPS、吞吐、延迟、Pod 驱逐事件和数据库维护结果进行复核。上述各步骤均对应官方文档中已有的资源分类、限制、伸缩或回收机制。([AWS 文档][3])

在服务器资源治理中，客观可执行项包括：使用官方推荐器识别过度配置实例；基于 CPU、内存、网络等指标调整实例规格；对低利用率实例执行关停或缩容；在 Kubernetes 中显式配置 requests 与 limits；使用 HPA 和节点自动伸缩减少固定容量冗余。AWS、Azure、Google Cloud 与 Kubernetes 官方文档均提供了上述能力的定义或操作入口。([AWS 文档][3])

在 SSD 资源治理中，客观可执行项包括：调整云 SSD 卷类型、容量、IOPS 和吞吐；删除或处理空闲 Persistent Disk；对文件系统执行 discard/TRIM；为容器临时存储设置 request、limit 和 `emptyDir.sizeLimit`；清理未使用 Docker 对象；对数据库执行与具体引擎匹配的空间维护命令。AWS EBS、Azure Managed Disks、Google Compute Engine、Linux、Kubernetes、Docker、PostgreSQL、MySQL 和 MongoDB 官方文档分别给出了这些机制的边界、行为或限制。([AWS 文档][11])

## 5. 结论

企业节省服务器资源的核心事实基础是：服务器规格、数量与运行状态可以依据利用率、负载指标和官方推荐器进行调整；容器资源可以通过 requests、limits、配额和自动伸缩进行声明、限制与动态变更。企业节省 SSD 资源的核心事实基础是：块存储容量、IOPS 与吞吐可以依据官方推荐与计费模型进行右型化；文件系统未使用块可通过 discard/TRIM 通知底层设备；容器临时存储、镜像层、日志与数据库文件膨胀可通过官方机制限制或回收。上述路径不是经验性主张，而是由云平台、Kubernetes、Linux、Docker 与主流数据库官方文档中定义的功能和行为共同支持。([AWS 文档][1])

## 参考文献

[1] AWS Well-Architected Cost Optimization Pillar：Select the correct resource type, size, and number。([AWS 文档][1])
[2] AWS Compute Optimizer：EC2 instance recommendations。([AWS 文档][3])
[3] AWS Compute Optimizer：Amazon EBS volume recommendations。([AWS 文档][11])
[4] AWS Cost Management：Cost Optimization Hub。([AWS 文档][21])
[5] Microsoft Azure Advisor：Cost recommendations。([微软学习][22])
[6] Microsoft Azure Advisor：Resize or shut down underutilized VMs / VMSS。([微软学习][4])
[7] Microsoft Azure Virtual Machines：Managed disk types and Premium SSD v2。([微软学习][13])
[8] Google Cloud Compute Engine：Idle VM recommendations and idle resource recommendations。([Google Cloud Documentation][5])
[9] Kubernetes Documentation：Resource Management for Pods and Containers。([Kubernetes][10])
[10] Kubernetes Documentation：Horizontal Pod Autoscaling。([Kubernetes][7])
[11] Kubernetes Documentation：Local ephemeral storage。([Kubernetes][16])
[12] Docker Docs：Prune unused Docker objects。([Docker Documentation][17])
[13] Linux man-pages：fstrim(8)。([man7.org][15])
[14] PostgreSQL Documentation：Routine Vacuuming and VACUUM。([PostgreSQL][18])
[15] MySQL Reference Manual：OPTIMIZE TABLE Statement。([MySQL开发者专区][19])
[16] MongoDB Manual：compact command。([mongodb.com][20])

[1]: https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/select-the-correct-resource-type-size-and-number.html "Select the correct resource type, size, and number - Cost Optimization Pillar"
[2]: https://docs.aws.amazon.com/cost-management/latest/userguide/ce-rightsizing.html?utm_source=chatgpt.com "Optimizing your cost with rightsizing recommendations"
[3]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recommendations.html "Get EC2 instance recommendations from Compute Optimizer - Amazon Elastic Compute Cloud"
[4]: https://learn.microsoft.com/en-us/azure/advisor/advisor-cost-recommendations "Optimize virtual machine (VM) or virtual machine scale set (VMSS) spend by resizing or shutting down underutilized instances - Azure Advisor | Microsoft Learn"
[5]: https://docs.cloud.google.com/compute/docs/instances/idle-vm-recommendations-overview "Idle VM recommendations  |  Compute Engine  |  Google Cloud Documentation"
[6]: https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scale-based-on-demand.html?utm_source=chatgpt.com "Dynamic scaling for Amazon EC2 Auto Scaling"
[7]: https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/ "Horizontal Pod Autoscaling | Kubernetes"
[8]: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md?utm_source=chatgpt.com "autoscaler/cluster-autoscaler/FAQ.md at master"
[9]: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/?utm_source=chatgpt.com "Resource Management for Pods and Containers"
[10]: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ "Resource Management for Pods and Containers | Kubernetes"
[11]: https://docs.aws.amazon.com/compute-optimizer/latest/ug/view-ebs-recommendations.html "Viewing Amazon EBS volume recommendations - AWS Compute Optimizer"
[12]: https://aws.amazon.com/ebs/general-purpose/?utm_source=chatgpt.com "Amazon EBS General Purpose Volumes"
[13]: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types "Select a disk type for Azure IaaS VMs - managed disks - Azure Virtual Machines | Microsoft Learn"
[14]: https://docs.cloud.google.com/compute/docs/viewing-and-applying-idle-resources-recommendations "View and apply idle resources recommendations  |  Compute Engine  |  Google Cloud Documentation"
[15]: https://man7.org/linux/man-pages/man8/fstrim.8.html "fstrim(8) - Linux manual page"
[16]: https://kubernetes.io/docs/concepts/storage/ephemeral-storage/ "Local ephemeral storage | Kubernetes"
[17]: https://docs.docker.com/engine/manage-resources/pruning/ "Prune unused Docker objects | Docker Docs"
[18]: https://www.postgresql.org/docs/current/routine-vacuuming.html "PostgreSQL: Documentation: 18: 24.1. Routine Vacuuming"
[19]: https://dev.mysql.com/doc/en/optimize-table.html "MySQL :: MySQL 9.7 Reference Manual :: 15.7.3.4 OPTIMIZE TABLE Statement"
[20]: https://www.mongodb.com/docs/manual/reference/command/compact/ "compact (database command) - Database Manual - MongoDB Docs"
[21]: https://docs.aws.amazon.com/cost-management/latest/userguide/cost-optimization-hub.html "Identifying opportunities with Cost Optimization Hub - AWS Cost Management"
[22]: https://learn.microsoft.com/en-us/azure/advisor/advisor-reference-cost-recommendations "Cost recommendations - Azure Advisor | Microsoft Learn"
