SRCS=	top.sv vga-sig.sv vga_sync_gen.sv por.sv
PLATFORM_SRCS=	machxo2/platform.sv
TBS= vga_sync_gen_tb.sv top_tb.sv

_srcs= $(addprefix rtl/,${SRCS})
_platform_srcs= $(addprefix rtl/,${PLATFORM_SRCS})
_tbs= $(addprefix tb/,${TBS})

DIAMONDPRJ=	fpgavga.ldf

MODELSIMDIR?=	/opt/altera/16.0/modelsim_ase/linux
DIAMONDDIR?=	/usr/local/diamond/3.7_x64/

define synplify_get_impl
$(shell ruby -rnokogiri -e '
p = Nokogiri::XML(File.read(ARGV[0]))
r = {
project: p.xpath("//BaliProject/@title"),
impl: p.xpath("//BaliProject/@default_implementation"),
dir: p.xpath("//BaliProject/Implementation[@title=//BaliProject/@default_implementation]/@dir"),
}
r[:synprj] = "#{r[:project]}_#{r[:impl]}_synplify.tcl"
print r[ARGV[1].to_sym]
' ${DIAMONDPRJ} $1)
endef

define SYNPLIFY ?=
cd $(call synplify_get_impl,dir) && \
rm synlog/report/*; \
env LD_LIBRARY_PATH=${DIAMONDDIR}/bin/lin64 \
SYNPLIFY_PATH=${DIAMONDDIR}/synpbase \
${DIAMONDDIR}/bin/lin64/synpwrap -prj $(call synplify_get_impl,synprj); \
e=$$?; \
cat synlog/report/*.txt; \
exit $$e
endef

all: simulate

work:
	${MODELSIMDIR}/vlib work

lint: ${SRCS:.sv=-lint}

%-lint: %.sv
	verilator -Dsynthesis --lint-only -Wall $^

compile: compile-modelsim.stamp compile-synplify.stamp

compile-modelsim.stamp: work ${_srcs} ${_tbs}
	${MODELSIMDIR}/vlog -sv12compat -lint ${_srcs} ${_tbs}
	touch $@

compile-synplify.stamp: ${_srcs} ${_platform_srcs} ${SYNPLIFYPRJ}
	${SYNPLIFY}
	touch $@

simulate: $(patsubst %.sv,%.vcd,${TBS})

%.vcd: compile-modelsim.stamp
	${MODELSIMDIR}/vsim -c -do 'vcd file $@; vcd add -r *; run -all' ${@:.vcd=}
