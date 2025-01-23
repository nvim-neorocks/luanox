<script lang="ts">
  import {
    Area,
    Axis,
    Chart,
    Svg,
    Tooltip,
    Highlight,
    AreaChart,
    Points,
  } from "layerchart";
  import { scaleTime } from "d3-scale";
  import { timeFormat } from "d3-time-format";
  import { parseDate } from "$lib/date";

  // TODO: stop hardcoding this
  // XXX: `value` is just a placeholder to hijack the dynamic chart y-axis
  let updates = [
    { date: parseDate("6 months ago"), value: 0.5, version: "9.0.3" },
    { date: parseDate("4 months ago"), value: 0.5, version: "9.1.0" },
    { date: parseDate("3 months ago"), value: 0.5, version: "9.1.1" },
  ];

  // TODO: stop hardcoding this
  let downloadsMultipleVersions = new Map<string, Array<Object>>([
    [
      "9.1.1",
      [
        { date: parseDate("2 weeks ago"), value: 218 },
        { date: parseDate("1 week ago"), value: 454 },
        { date: parseDate("4 days ago"), value: 308 },
        { date: parseDate("3 days ago"), value: 812 },
        { date: parseDate("2 days ago"), value: 564 },
        { date: parseDate("1 days ago"), value: 511 },
      ],
    ],
    [
      "9.1.0",
      [
        { date: parseDate("2 weeks ago"), value: 418 },
        { date: parseDate("1 week ago"), value: 264 },
        { date: parseDate("4 days ago"), value: 246 },
        { date: parseDate("3 days ago"), value: 212 },
        { date: parseDate("2 days ago"), value: 184 },
        { date: parseDate("1 days ago"), value: 111 },
      ],
    ],
    [
      "9.0.3",
      [
        { date: parseDate("2 weeks ago"), value: 218 },
        { date: parseDate("1 week ago"), value: 172 },
        { date: parseDate("4 days ago"), value: 134 },
        { date: parseDate("3 days ago"), value: 102 },
        { date: parseDate("2 days ago"), value: 89 },
        { date: parseDate("1 days ago"), value: 41 },
      ],
    ],
  ]);

  function formatDate(date: Date, format: string) {
    const fmt = timeFormat(format);
    return fmt(date);
  }
</script>

<h2 class="text-lg font-semibold">Updates timeline</h2>
<div class="h-[300px] p-4 border border-dark-grey rounded">
  <Chart
    data={updates}
    x="date"
    xScale={scaleTime()}
    y="value"
    yDomain={[0, 1]}
    yNice
    padding={{ left: 0, bottom: 16 }}
    tooltip={{ mode: "bisect-x" }}
    let:x
    let:y
  >
    <Svg>
      <Axis
        placement="left"
        classes={{
          rule: "stroke-dark-grey opacity-0",
          tick: "stroke-dark-grey opacity-0",
          tickLabel: "fill-dark-grey font-semibold opacity-0",
        }}
      />
      <Axis
        placement="bottom"
        grid
        rule
        format={(date) => `${date.getMonth()}/${date.getDate()}`}
        classes={{
          rule: "stroke-dark-grey opacity-10",
          tick: "stroke-dark-grey opacity-50",
          tickLabel: "fill-dark-grey font-semibold",
        }}
      />
      <Points data={updates} {x} {y} fill="var(--blue)" />
      <Area
        line={{ class: "stroke-2 stroke-blue" }}
        class="fill-transparent"
      />
      <Highlight points lines />
    </Svg>
    <Tooltip.Root
      class="bg-surface border border-dark-grey font-semibold whitespace-nowrap"
      let:data
    >
      <Tooltip.Header>{formatDate(data.date, "%a, %B %d, %Y")}</Tooltip.Header>
      <Tooltip.List>
        <Tooltip.Item label="version" value={data.version} />
      </Tooltip.List>
    </Tooltip.Root>
  </Chart>
</div>

<h2 class="mt-4 text-lg font-semibold">Downloads over the last 30 days</h2>
<div class="h-[300px] p-2 md:p-4 border border-dark-grey rounded">
  <AreaChart
    x="date"
    y="value"
    series={[
      {
        key: "9.1.1",
        data: downloadsMultipleVersions.get("9.1.1"),
        color: "var(--blue)",
      },
      {
        key: "9.1.0",
        data: downloadsMultipleVersions.get("9.1.0"),
        color: "var(--red)",
      },
      {
        key: "9.0.3",
        data: downloadsMultipleVersions.get("9.0.3"),
        color: "var(--yellow)",
      },
    ]}
    points
    legend
    seriesLayout="overlap"
    props={{
      area: {
        strokeWidth: 2,
      },
      yAxis: {
        grid: true,
        rule: true,
        placement: "left",
        classes: {
          rule: "stroke-dark-grey opacity-10",
          tick: "stroke-dark-grey opacity-50",
          tickLabel: "fill-dark-grey font-semibold",
        },
      },
      xAxis: {
        grid: true,
        rule: true,
        placement: "bottom",
        classes: {
          rule: "stroke-dark-grey opacity-10",
          tick: "stroke-dark-grey opacity-50",
          tickLabel: "fill-dark-grey font-semibold",
        },
      },
      tooltip: {
        root: {
          classes: {
            root: "bg-surface border border-dark-grey font-semibold whitespace-nowrap",
          },
        },
      },
    }}
  />
</div>
